package service;

import entity.Invoice;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

public class VnPayService {
    private static final String VERSION = "2.1.0";
    private static final String COMMAND_PAY = "pay";
    private static final String DEFAULT_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    private static final String DEFAULT_TMN_CODE = "2QXUI4J4";
    private static final String DEFAULT_HASH_SECRET = "SECRETKEY";

    public String createPaymentUrl(HttpServletRequest request, Invoice invoice) {
        if (invoice == null || invoice.getId() == null) {
            throw new IllegalArgumentException("Không tìm thấy hóa đơn để thanh toán VNPay.");
        }
        if (invoice.getTotalAmount() == null || invoice.getTotalAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Số tiền thanh toán VNPay không hợp lệ.");
        }

        ServletContext context = request.getServletContext();
        String txnRef = buildTxnRef(invoice.getId());
        String orderInfo = "Thanh toan hoa don Le Royal #" + invoice.getId();
        String amount = invoice.getTotalAmount()
                .multiply(new BigDecimal("100"))
                .setScale(0, RoundingMode.HALF_UP)
                .toPlainString();

        Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.US);
        String createDate = formatter.format(calendar.getTime());
        calendar.add(Calendar.MINUTE, 15);
        String expireDate = formatter.format(calendar.getTime());

        Map<String, String> params = new HashMap<>();
        params.put("vnp_Version", VERSION);
        params.put("vnp_Command", COMMAND_PAY);
        params.put("vnp_TmnCode", config(context, "vnpay.tmnCode", "VNPAY_TMN_CODE", DEFAULT_TMN_CODE));
        params.put("vnp_Amount", amount);
        params.put("vnp_CurrCode", "VND");
        params.put("vnp_TxnRef", txnRef);
        params.put("vnp_OrderInfo", orderInfo);
        params.put("vnp_OrderType", "other");
        params.put("vnp_Locale", "vn");
        params.put("vnp_ReturnUrl", buildBaseUrl(request) + request.getContextPath() + "/payment/vnpay-return");
        params.put("vnp_IpnUrl", buildBaseUrl(request) + request.getContextPath() + "/payment/vnpay-ipn");
        params.put("vnp_IpAddr", clientIp(request));
        params.put("vnp_CreateDate", createDate);
        params.put("vnp_ExpireDate", expireDate);

        String query = buildQuery(params);
        String secureHash = hmacSHA512(config(context, "vnpay.hashSecret", "VNPAY_HASH_SECRET", DEFAULT_HASH_SECRET), query);
        return config(context, "vnpay.payUrl", "VNPAY_PAY_URL", DEFAULT_PAY_URL) + "?" + query + "&vnp_SecureHash=" + secureHash;
    }

    public boolean verifyReturn(HttpServletRequest request) {
        Map<String, String> params = extractVnPayParams(request);
        String secureHash = params.remove("vnp_SecureHash");
        params.remove("vnp_SecureHashType");
        if (secureHash == null || secureHash.trim().isEmpty()) {
            return false;
        }
        String signedData = buildQuery(params);
        String expected = hmacSHA512(config(request.getServletContext(), "vnpay.hashSecret", "VNPAY_HASH_SECRET", DEFAULT_HASH_SECRET), signedData);
        return expected.equalsIgnoreCase(secureHash);
    }

    public Map<String, String> extractVnPayParams(HttpServletRequest request) {
        Map<String, String> params = new HashMap<>();
        Enumeration<String> names = request.getParameterNames();
        while (names.hasMoreElements()) {
            String name = names.nextElement();
            if (name != null && name.startsWith("vnp_")) {
                String value = request.getParameter(name);
                if (value != null && !value.trim().isEmpty()) {
                    params.put(name, value);
                }
            }
        }
        return params;
    }

    public Long invoiceIdFromTxnRef(String txnRef) {
        if (txnRef == null) {
            return null;
        }
        String normalized = txnRef.trim();
        if (normalized.startsWith("LR")) {
            normalized = normalized.substring(2);
        }
        try {
            return Long.valueOf(normalized);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public String buildTxnRef(Long invoiceId) {
        return "LR" + invoiceId;
    }

    private String buildQuery(Map<String, String> params) {
        List<String> keys = new ArrayList<>(params.keySet());
        Collections.sort(keys);
        StringBuilder query = new StringBuilder();
        for (String key : keys) {
            String value = params.get(key);
            if (value == null || value.trim().isEmpty()) {
                continue;
            }
            if (query.length() > 0) {
                query.append('&');
            }
            query.append(urlEncode(key)).append('=').append(urlEncode(value));
        }
        return query.toString();
    }

    private String hmacSHA512(String key, String data) {
        try {
            Mac hmac512 = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac512.init(secretKey);
            byte[] bytes = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hash = new StringBuilder(bytes.length * 2);
            for (byte b : bytes) {
                hash.append(String.format("%02x", b & 0xff));
            }
            return hash.toString();
        } catch (Exception e) {
            throw new IllegalStateException("Không thể tạo chữ ký VNPay.", e);
        }
    }

    private String urlEncode(String value) {
        try {
            return URLEncoder.encode(value, StandardCharsets.UTF_8.name());
        } catch (UnsupportedEncodingException e) {
            throw new IllegalStateException(e);
        }
    }

    private String buildBaseUrl(HttpServletRequest request) {
        int port = request.getServerPort();
        boolean defaultPort = ("http".equals(request.getScheme()) && port == 80)
                || ("https".equals(request.getScheme()) && port == 443);
        return request.getScheme() + "://" + request.getServerName() + (defaultPort ? "" : ":" + port);
    }

    private String clientIp(HttpServletRequest request) {
        String forwardedFor = request.getHeader("X-Forwarded-For");
        if (forwardedFor != null && !forwardedFor.trim().isEmpty()) {
            return forwardedFor.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }

    private String config(ServletContext context, String initParam, String envName, String fallback) {
        String value = context == null ? null : context.getInitParameter(initParam);
        if (value == null || value.trim().isEmpty()) {
            value = System.getProperty(initParam);
        }
        if (value == null || value.trim().isEmpty()) {
            value = System.getenv(envName);
        }
        return value == null || value.trim().isEmpty() ? fallback : value.trim();
    }
}

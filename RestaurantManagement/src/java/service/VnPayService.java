package service;

import entity.Invoice;
import entity.RankTopUp;
import enums.TopUpType;
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
    public static final BigDecimal MIN_VNPAY_AMOUNT = new BigDecimal("1000");

    public String createPaymentUrl(HttpServletRequest request, Invoice invoice) {
        if (invoice == null || invoice.getId() == null) {
            throw new IllegalArgumentException("Không tìm thấy hóa đơn để thanh toán VNPay.");
        }
        if (invoice.getTotalAmount() == null || invoice.getTotalAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Số tiền thanh toán VNPay không hợp lệ.");
        }

        ServletContext context = request.getServletContext();
        String txnRef = buildTxnRef(invoice.getId(), "LR");
        String orderInfo = "Thanh_toan_hoa_don_Le_Royal_" + invoice.getId();
        String amount = invoice.getTotalAmount()
                .multiply(new BigDecimal("100"))
                .setScale(0, RoundingMode.HALF_UP)
                .toPlainString();

        TimeZone vnTz = TimeZone.getTimeZone("Asia/Ho_Chi_Minh");
        Calendar calendar = Calendar.getInstance(vnTz);
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.US);
        formatter.setTimeZone(vnTz);
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
        params.put("vnp_IpAddr", clientIp(request));
        params.put("vnp_CreateDate", createDate);
        params.put("vnp_ExpireDate", expireDate);

        String hashData = buildHashData(params);
        String query = buildQuery(params);
        String secureHash = hmacSHA512(config(context, "vnpay.hashSecret", "VNPAY_HASH_SECRET", DEFAULT_HASH_SECRET), hashData);
        return config(context, "vnpay.payUrl", "VNPAY_PAY_URL", DEFAULT_PAY_URL) + "?" + query + "&vnp_SecureHash=" + secureHash;
    }

    public boolean verifyReturn(HttpServletRequest request) {
        Map<String, String> params = extractVnPayParams(request);
        String secureHash = params.remove("vnp_SecureHash");
        params.remove("vnp_SecureHashType");
        if (secureHash == null || secureHash.trim().isEmpty()) {
            return false;
        }
        String hashData = buildHashData(params);
        String expected = hmacSHA512(config(request.getServletContext(), "vnpay.hashSecret", "VNPAY_HASH_SECRET", DEFAULT_HASH_SECRET), hashData);
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

    public static BigDecimal getActualVnPayAmount(RankTopUp topUp) {
        return topUp.getFinalAmount().max(MIN_VNPAY_AMOUNT);
    }

    public String createTopUpPaymentUrl(HttpServletRequest request, RankTopUp topUp) {
        if (topUp == null || topUp.getId() == null) {
            throw new IllegalArgumentException("Không tìm thấy giao dịch nạp để thanh toán VNPay.");
        }

        BigDecimal vnpAmount = getActualVnPayAmount(topUp);

        ServletContext context = request.getServletContext();
        String txnRef = "TOPUP_" + topUp.getId();
        String orderInfo = "Nap_" + (topUp.getTopupType() == TopUpType.RANK ? "hang" : "xu") + "_Le_Royal_" + topUp.getId();
        String amount = vnpAmount
                .multiply(new BigDecimal("100"))
                .setScale(0, RoundingMode.HALF_UP)
                .toPlainString();

        TimeZone vnTz = TimeZone.getTimeZone("Asia/Ho_Chi_Minh");
        Calendar calendar = Calendar.getInstance(vnTz);
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.US);
        formatter.setTimeZone(vnTz);
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
        params.put("vnp_IpAddr", clientIp(request));
        params.put("vnp_CreateDate", createDate);
        params.put("vnp_ExpireDate", expireDate);

        String hashData = buildHashData(params);
        String query = buildQuery(params);
        String secureHash = hmacSHA512(config(context, "vnpay.hashSecret", "VNPAY_HASH_SECRET", DEFAULT_HASH_SECRET), hashData);
        return config(context, "vnpay.payUrl", "VNPAY_PAY_URL", DEFAULT_PAY_URL) + "?" + query + "&vnp_SecureHash=" + secureHash;
    }

    public Long topUpIdFromTxnRef(String txnRef) {
        if (txnRef == null) return null;
        String t = txnRef.trim();
        if (t.startsWith("TOPUP_")) {
            try {
                return Long.valueOf(t.substring(6));
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }

    public String detectTxnRefPrefix(String txnRef) {
        if (txnRef == null || txnRef.trim().isEmpty()) return null;
        String t = txnRef.trim();
        if (t.startsWith("TOPUP_")) return "TOPUP";
        if (t.startsWith("LR")) return "LR";
        return null;
    }

    public Long entityIdFromTxnRef(String txnRef) {
        if (txnRef == null) return null;
        String t = txnRef.trim();
        if (t.startsWith("TOPUP_")) {
            try { return Long.valueOf(t.substring(6)); }
            catch (NumberFormatException e) { return null; }
        }
        if (t.startsWith("LR")) {
            try { return Long.valueOf(t.substring(2)); }
            catch (NumberFormatException e) { return null; }
        }
        return null;
    }

    public String buildTxnRef(Long entityId, String prefix) {
        return prefix + entityId;
    }

    // Backward compatibility
    public Long invoiceIdFromTxnRef(String txnRef) {
        return entityIdFromTxnRef(txnRef);
    }

    public String buildTxnRef(Long invoiceId) {
        return buildTxnRef(invoiceId, "LR");
    }

    private String buildHashData(Map<String, String> params) {
        List<String> keys = new ArrayList<>(params.keySet());
        Collections.sort(keys);
        StringBuilder hash = new StringBuilder();
        for (String key : keys) {
            String value = params.get(key);
            if (value == null || value.trim().isEmpty()) {
                continue;
            }
            if (hash.length() > 0) {
                hash.append('&');
            }
            hash.append(key).append('=').append(urlEncode(value));
        }
        return hash.toString();
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
            return URLEncoder.encode(value, StandardCharsets.US_ASCII.name());
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

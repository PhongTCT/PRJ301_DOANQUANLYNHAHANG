package util;

import java.io.UnsupportedEncodingException;
import java.text.NumberFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletContext;

public class EmailUtil {

    private static final ExecutorService emailExecutor = Executors.newFixedThreadPool(5);
    private static String smtpHost;
    private static int smtpPort;
    private static String smtpUsername;
    private static String smtpPassword;
    private static String fromEmail;
    private static String fromName;
    private static boolean initialized = false;
    private static boolean smtpEnabled = false;

    public static void init(ServletContext ctx) {
        if (initialized) return;
        initialized = true;

        smtpHost = ctx.getInitParameter("smtp.host");
        String portStr = ctx.getInitParameter("smtp.port");
        smtpUsername = ctx.getInitParameter("smtp.username");
        smtpPassword = ctx.getInitParameter("smtp.password");
        fromEmail = ctx.getInitParameter("smtp.from");
        fromName = ctx.getInitParameter("smtp.fromName");

        if (smtpHost == null || smtpHost.trim().isEmpty()) {
            smtpEnabled = false;
            return;
        }

        try {
            smtpPort = portStr != null ? Integer.parseInt(portStr.trim()) : 587;
        } catch (NumberFormatException e) {
            smtpPort = 587;
        }

        if (fromEmail == null || fromEmail.trim().isEmpty()) {
            fromEmail = smtpUsername;
        }
        if (fromName == null || fromName.trim().isEmpty()) {
            fromName = "Le Royal Restaurant";
        }

        smtpEnabled = smtpHost != null && !smtpHost.trim().isEmpty();
    }

    public static void sendVerifyEmail(String toEmail, String toName, String verifyLink) {
        String subject = "Verify your email - Le Royal Restaurant";
        String html = buildVerifyEmailHtml(toName, verifyLink);
        sendEmailAsync(toEmail, subject, html);
    }

    public static void sendPaymentConfirmEmail(String toEmail, String toName, String orderDetailsHtml,
            String totalAmount, String paymentMethod, String paidAt) {
        String subject = "Payment confirmed - Le Royal Restaurant";
        String html = buildPaymentConfirmHtml(toName, orderDetailsHtml, totalAmount, paymentMethod, paidAt);
        sendEmailAsync(toEmail, subject, html);
    }

    public static void sendEmailAsync(String toEmail, String subject, String htmlContent) {
        if (!smtpEnabled) {
            System.err.println("[EmailUtil] SMTP not configured. Email not sent to: " + toEmail);
            return;
        }
        emailExecutor.submit(() -> {
            try {
                sendEmail(toEmail, subject, htmlContent);
            } catch (Exception e) {
                System.err.println("[EmailUtil] Failed to send email to " + toEmail + ": " + e.getMessage());
            }
        });
    }

    private static void sendEmail(String toEmail, String subject, String htmlContent) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", String.valueOf(smtpPort));
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpUsername, smtpPassword);
            }
        });

        MimeMessage message = new MimeMessage(session);
        try {
            message.setFrom(new InternetAddress(fromEmail, fromName));
        } catch (UnsupportedEncodingException e) {
            message.setFrom(new InternetAddress(fromEmail));
        }
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setContent(htmlContent, "text/html; charset=UTF-8");
        message.setSentDate(new Date());

        Transport.send(message);
    }

    private static String buildVerifyEmailHtml(String name, String verifyLink) {
        return "<!DOCTYPE html>" +
        "<html>" +
        "<head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">" +
        "<style>" +
            "body{margin:0;padding:0;background-color:#f5f3ef;font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif}" +
            ".wrapper{max-width:600px;margin:0 auto;padding:20px 10px}" +
            ".card{background:#ffffff;border-radius:12px;overflow:hidden;box-shadow:0 2px 12px rgba(0,0,0,0.08)}" +
            ".header{background:linear-gradient(135deg,#1a1a2e 0%,#16213e 50%,#0f3460 100%);padding:36px 32px;text-align:center}" +
            ".header h1{margin:0;color:#d4af37;font-size:22px;font-weight:700;letter-spacing:1px}" +
            ".header p{margin:6px 0 0;color:#c0c0c0;font-size:13px}" +
            ".body{padding:36px 32px}" +
            ".body h2{margin:0 0 16px;color:#1a1a2e;font-size:20px}" +
            ".body p{margin:0 0 12px;color:#444;font-size:15px;line-height:1.6}" +
            ".btn-wrap{text-align:center;margin:28px 0}" +
            ".btn{display:inline-block;padding:14px 36px;background:linear-gradient(135deg,#d4af37,#c5a028);color:#1a1a2e!important;text-decoration:none;border-radius:8px;font-size:15px;font-weight:700;letter-spacing:0.5px}" +
            ".footer{background:#faf8f5;padding:24px 32px;text-align:center;border-top:1px solid #e8e3db}" +
            ".footer p{margin:4px 0;color:#888;font-size:12px}" +
            ".note{font-size:13px;color:#888;margin-top:20px;padding:12px;background:#faf8f5;border-radius:8px}" +
        "</style></head>" +
        "<body>" +
        "<div class=\"wrapper\">" +
        "<div class=\"card\">" +
        "<div class=\"header\">" +
        "<h1>✦ LE ROYAL ✦</h1>" +
        "<p>Fine Dining Restaurant</p>" +
        "</div>" +
        "<div class=\"body\">" +
        "<h2>Welcome" + (name != null && !name.trim().isEmpty() ? ", " + escapeHtml(name.trim()) : "") + "!</h2>" +
        "<p>Thank you for creating an account at <strong>Le Royal Restaurant</strong>. We are delighted to have you with us.</p>" +
        "<p>Please verify your email address by clicking the button below:</p>" +
        "<div class=\"btn-wrap\"><a href=\"" + escapeHtml(verifyLink) + "\" class=\"btn\">Verify Email Address</a></div>" +
        "<p class=\"note\">This link will expire in <strong>24 hours</strong>. If you did not create this account, please ignore this email.</p>" +
        "</div>" +
        "<div class=\"footer\">" +
        "<p><strong>Le Royal Restaurant</strong></p>" +
        "<p>123 Nguyen Hue Street, District 1, Ho Chi Minh City</p>" +
        "<p>Phone: (028) 3822-1234 &bull; Email: contact@leroyal.vn</p>" +
        "<p style=\"margin-top:8px\">&copy; 2026 Le Royal Restaurant. All rights reserved.</p>" +
        "</div>" +
        "</div>" +
        "</div>" +
        "</body></html>";
    }

    public static String buildPaymentConfirmHtml(String name, String orderDetailsHtml,
            String totalAmount, String paymentMethod, String paidAt) {
        return "<!DOCTYPE html>" +
        "<html>" +
        "<head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">" +
        "<style>" +
            "body{margin:0;padding:0;background-color:#f5f3ef;font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif}" +
            ".wrapper{max-width:600px;margin:0 auto;padding:20px 10px}" +
            ".card{background:#ffffff;border-radius:12px;overflow:hidden;box-shadow:0 2px 12px rgba(0,0,0,0.08)}" +
            ".header{background:linear-gradient(135deg,#1a1a2e 0%,#16213e 50%,#0f3460 100%);padding:36px 32px;text-align:center}" +
            ".header h1{margin:0;color:#d4af37;font-size:22px;font-weight:700;letter-spacing:1px}" +
            ".header p{margin:6px 0 0;color:#c0c0c0;font-size:13px}" +
            ".body{padding:36px 32px}" +
            ".body h2{margin:0 0 16px;color:#1a1a2e;font-size:20px}" +
            ".body p{margin:0 0 12px;color:#444;font-size:15px;line-height:1.6}" +
            ".detail-box{background:#faf8f5;border-radius:8px;padding:20px;margin:16px 0;border:1px solid #e8e3db}" +
            ".detail-box table{width:100%;border-collapse:collapse}" +
            ".detail-box td{padding:8px 0;font-size:14px;color:#444;border-bottom:1px solid #eee}" +
            ".detail-box td:last-child{text-align:right;font-weight:600}" +
            ".detail-box .total td{font-size:16px;font-weight:700;color:#1a1a2e;border-bottom:none;padding-top:12px}" +
            ".badge{display:inline-block;padding:4px 12px;border-radius:4px;font-size:12px;font-weight:600}" +
            ".badge-success{background:#e8f5e9;color:#2e7d32}" +
            ".review-box{background:linear-gradient(135deg,#faf8f5,#f5f3ef);border-radius:8px;padding:20px;margin:20px 0;text-align:center;border:1px solid #e8e3db}" +
            ".review-box p{margin:0 0 8px;font-size:14px;color:#444}" +
            ".footer{background:#faf8f5;padding:24px 32px;text-align:center;border-top:1px solid #e8e3db}" +
            ".footer p{margin:4px 0;color:#888;font-size:12px}" +
        "</style></head>" +
        "<body>" +
        "<div class=\"wrapper\">" +
        "<div class=\"card\">" +
        "<div class=\"header\">" +
        "<h1>✦ LE ROYAL ✦</h1>" +
        "<p>Fine Dining Restaurant</p>" +
        "</div>" +
        "<div class=\"body\">" +
        "<h2>Payment confirmed, " + escapeHtml(name) + "!</h2>" +
        "<p>Thank you for your reservation. We have received your payment and are excited to serve you.</p>" +
        "<div class=\"detail-box\">" +
        "<table>" +
            (orderDetailsHtml != null ? orderDetailsHtml : "") +
            "<tr class=\"total\"><td>Total Amount</td><td>" + escapeHtml(totalAmount) + "</td></tr>" +
        "</table>" +
        "</div>" +
        "<p><span class=\"badge badge-success\">PAID</span> via <strong>" + escapeHtml(paymentMethod) + "</strong> on " + escapeHtml(paidAt) + "</p>" +
        "<div class=\"review-box\">" +
        "<p><strong>Enjoyed your experience?</strong></p>" +
        "<p style=\"font-size:13px\">We would love to hear your feedback. Share your review and help us serve you better!</p>" +
        "</div>" +
        "</div>" +
        "<div class=\"footer\">" +
        "<p><strong>Le Royal Restaurant</strong></p>" +
        "<p>123 Nguyen Hue Street, District 1, Ho Chi Minh City</p>" +
        "<p>Phone: (028) 3822-1234 &bull; Email: contact@leroyal.vn</p>" +
        "<p style=\"margin-top:8px\">&copy; 2026 Le Royal Restaurant. All rights reserved.</p>" +
        "</div>" +
        "</div>" +
        "</div>" +
        "</body></html>";
    }

    private static String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
}

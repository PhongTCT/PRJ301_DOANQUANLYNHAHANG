package util;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.util.LinkedHashMap;
import java.util.Map;
import javax.servlet.http.Part;

public class CloudinaryUtil {
    private static final long MAX_IMAGE_BYTES = 5L * 1024L * 1024L;

    public static String uploadImage(Part imagePart, String folder) {
        if (imagePart == null || imagePart.getSize() <= 0) {
            return null;
        }
        if (!isImage(imagePart)) {
            throw new IllegalArgumentException("Uploaded file must be an image.");
        }
        if (imagePart.getSize() > MAX_IMAGE_BYTES) {
            throw new IllegalArgumentException("Image must be 5MB or smaller.");
        }

        String cloudName = requiredEnv("CLOUDINARY_CLOUD_NAME");
        String apiKey = requiredEnv("CLOUDINARY_API_KEY");
        String apiSecret = requiredEnv("CLOUDINARY_API_SECRET");
        long timestamp = System.currentTimeMillis() / 1000L;
        String normalizedFolder = normalizeFolder(folder);

        Map<String, String> fields = new LinkedHashMap<>();
        fields.put("folder", normalizedFolder);
        fields.put("timestamp", String.valueOf(timestamp));
        fields.put("api_key", apiKey);
        fields.put("signature", sign(normalizedFolder, timestamp, apiSecret));

        try {
            return postMultipart(cloudName, fields, imagePart);
        } catch (IOException e) {
            throw new IllegalArgumentException("Could not upload image to Cloudinary.");
        }
    }

    private static String postMultipart(String cloudName, Map<String, String> fields, Part imagePart) throws IOException {
        String boundary = "----LeRoyalCloudinary" + System.currentTimeMillis();
        URL url = new URL("https://api.cloudinary.com/v1_1/" + cloudName + "/image/upload");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setConnectTimeout(15000);
        connection.setReadTimeout(30000);
        connection.setDoOutput(true);
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);

        try (OutputStream output = connection.getOutputStream()) {
            for (Map.Entry<String, String> entry : fields.entrySet()) {
                writeField(output, boundary, entry.getKey(), entry.getValue());
            }
            writeFile(output, boundary, imagePart);
            output.write(("--" + boundary + "--\r\n").getBytes("UTF-8"));
        }

        int status = connection.getResponseCode();
        String body = readFully(status >= 200 && status < 300 ? connection.getInputStream() : connection.getErrorStream());
        if (status < 200 || status >= 300) {
            throw new IOException("Cloudinary upload failed: " + body);
        }

        String secureUrl = extractJsonString(body, "secure_url");
        if (secureUrl == null || secureUrl.trim().isEmpty()) {
            throw new IOException("Cloudinary response did not include secure_url.");
        }
        return secureUrl;
    }

    private static void writeField(OutputStream output, String boundary, String name, String value) throws IOException {
        output.write(("--" + boundary + "\r\n").getBytes("UTF-8"));
        output.write(("Content-Disposition: form-data; name=\"" + name + "\"\r\n\r\n").getBytes("UTF-8"));
        output.write((value + "\r\n").getBytes("UTF-8"));
    }

    private static void writeFile(OutputStream output, String boundary, Part part) throws IOException {
        String fileName = safeFileName(part);
        String contentType = part.getContentType() == null ? "application/octet-stream" : part.getContentType();
        output.write(("--" + boundary + "\r\n").getBytes("UTF-8"));
        output.write(("Content-Disposition: form-data; name=\"file\"; filename=\"" + fileName + "\"\r\n").getBytes("UTF-8"));
        output.write(("Content-Type: " + contentType + "\r\n\r\n").getBytes("UTF-8"));
        try (InputStream input = part.getInputStream()) {
            byte[] buffer = new byte[8192];
            int read;
            while ((read = input.read(buffer)) != -1) {
                output.write(buffer, 0, read);
            }
        }
        output.write("\r\n".getBytes("UTF-8"));
    }

    private static String sign(String folder, long timestamp, String apiSecret) {
        return sha1("folder=" + folder + "&timestamp=" + timestamp + apiSecret);
    }

    private static String sha1(String input) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-1");
            byte[] bytes = digest.digest(input.getBytes("UTF-8"));
            StringBuilder result = new StringBuilder();
            for (byte value : bytes) {
                result.append(String.format("%02x", value));
            }
            return result.toString();
        } catch (Exception e) {
            throw new IllegalArgumentException("Could not sign Cloudinary upload.");
        }
    }

    private static String readFully(InputStream input) throws IOException {
        if (input == null) {
            return "";
        }
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        byte[] buffer = new byte[4096];
        int read;
        while ((read = input.read(buffer)) != -1) {
            output.write(buffer, 0, read);
        }
        return new String(output.toByteArray(), "UTF-8");
    }

    private static String extractJsonString(String json, String key) {
        String token = "\"" + key + "\"";
        int keyIndex = json.indexOf(token);
        if (keyIndex < 0) {
            return null;
        }
        int colonIndex = json.indexOf(':', keyIndex + token.length());
        int startQuote = json.indexOf('"', colonIndex + 1);
        if (colonIndex < 0 || startQuote < 0) {
            return null;
        }
        StringBuilder value = new StringBuilder();
        boolean escaped = false;
        for (int i = startQuote + 1; i < json.length(); i++) {
            char current = json.charAt(i);
            if (escaped) {
                value.append(current);
                escaped = false;
            } else if (current == '\\') {
                escaped = true;
            } else if (current == '"') {
                return value.toString();
            } else {
                value.append(current);
            }
        }
        return null;
    }

    private static boolean isImage(Part part) {
        String contentType = part.getContentType();
        return contentType != null && contentType.toLowerCase().startsWith("image/");
    }

    private static String requiredEnv(String name) {
        String value = System.getenv(name);
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("Missing Cloudinary setting: " + name + ".");
        }
        return value.trim();
    }

    private static String normalizeFolder(String folder) {
        String value = folder == null || folder.trim().isEmpty() ? "le-royal" : folder.trim();
        return value.replace("\\", "/");
    }

    private static String safeFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header != null) {
            String[] tokens = header.split(";");
            for (String token : tokens) {
                String trimmed = token.trim();
                if (trimmed.startsWith("filename=")) {
                    String name = trimmed.substring("filename=".length()).replace("\"", "");
                    int slash = Math.max(name.lastIndexOf('/'), name.lastIndexOf('\\'));
                    return slash >= 0 ? name.substring(slash + 1) : name;
                }
            }
        }
        return "upload.jpg";
    }
}

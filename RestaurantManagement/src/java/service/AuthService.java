package service;

import dao.UserDAO;
import dao.VerificationTokenDAO;
import dto.FacebookLoginDraft;
import dto.GoogleLoginDraft;
import entity.User;
import entity.VerificationToken;
import enums.UserStatus;
import enums.VerificationTokenType;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import util.BCryptUtil;
import util.EmailUtil;

public class AuthService {
    private static final String GOOGLE_CLIENT_ID = "421816854411-gjtf8gr3ts2v9r866pk2s4n9mc1tvvs0.apps.googleusercontent.com";
    private static final String GOOGLE_TOKEN_INFO_URL = "https://oauth2.googleapis.com/tokeninfo?id_token=";
    private static final String GOOGLE_ACCESS_TOKEN_INFO_URL = "https://oauth2.googleapis.com/tokeninfo?access_token=";
    private static final String GOOGLE_USER_INFO_URL = "https://www.googleapis.com/oauth2/v3/userinfo";
    private static final String FACEBOOK_APP_ID = "2848239018885988";
    private static final String FACEBOOK_USER_INFO_URL = "https://graph.facebook.com/v19.0/me";

    private final UserDAO userDAO = new UserDAO();
    private final VerificationTokenDAO tokenDAO = new VerificationTokenDAO();

    public User login(String username, String password) {
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Please enter username and password.");
        }
        User user = userDAO.searchByUsernameOrEmail(username.trim());
        if (user == null) {
            throw new IllegalArgumentException("Account does not exist.");
        }
        if (user.getStatus() != UserStatus.ACTIVE) {
            throw new IllegalArgumentException("Account is not active. Please verify your email first.");
        }
        if (user.getPassword() == null || !BCryptUtil.checkPassword(password, user.getPassword())) {
            throw new IllegalArgumentException("Incorrect password.");
        }
        return user;
    }

    public User loginWithGoogleCredential(String credential) {
        return loginExistingGoogleUser(buildGoogleLoginDraftFromCredential(credential));
    }

    public User loginWithGoogleAccessToken(String accessToken) {
        return loginExistingGoogleUser(buildGoogleLoginDraftFromAccessToken(accessToken));
    }

    public GoogleLoginDraft buildGoogleLoginDraftFromCredential(String credential) {
        if (credential == null || credential.trim().isEmpty()) {
            throw new IllegalArgumentException("Google credential is missing.");
        }

        return toDraft(verifyGoogleCredential(credential.trim()));
    }

    public GoogleLoginDraft buildGoogleLoginDraftFromAccessToken(String accessToken) {
        if (accessToken == null || accessToken.trim().isEmpty()) {
            throw new IllegalArgumentException("Google access token is missing.");
        }

        return toDraft(verifyGoogleAccessToken(accessToken.trim()));
    }

    public User findExistingGoogleUser(GoogleLoginDraft draft) {
        if (draft == null) {
            return null;
        }

        User user = userDAO.searchByGoogleId(draft.getGoogleId());
        if (user == null) {
            user = userDAO.searchByEmail(draft.getEmail());
        }
        return user;
    }

    public User loginExistingGoogleUser(GoogleLoginDraft draft) {
        validateGoogleDraft(draft);
        if (findExistingGoogleUser(draft) == null) {
            throw new IllegalArgumentException("Please complete your account information first.");
        }

        User user = userDAO.findOrCreateGoogleUser(
                draft.getGoogleId(),
                draft.getEmail(),
                draft.getFullName(),
                draft.getAvatarUrl());
        if (user.getStatus() != UserStatus.ACTIVE) {
            throw new IllegalArgumentException("Account is not active. Please verify your email first.");
        }
        return user;
    }

    public User registerGoogleUser(GoogleLoginDraft draft, String fullName, String phone, String dateOfBirth) {
        validateGoogleDraft(draft);
        String cleanName = fullName == null ? "" : fullName.trim();
        String cleanPhone = phone == null ? "" : phone.trim();

        if (cleanName.isEmpty()) {
            throw new IllegalArgumentException("Please enter your full name.");
        }
        if (cleanPhone.isEmpty()) {
            throw new IllegalArgumentException("Please enter your phone number.");
        }

        User user = userDAO.findOrCreateGoogleUser(
                draft.getGoogleId(),
                draft.getEmail(),
                cleanName,
                draft.getAvatarUrl(),
                cleanPhone,
                parseDateOfBirth(dateOfBirth));

        user.setStatus(UserStatus.PENDING);
        user.setEmailVerified(false);
        userDAO.update(user);

        sendVerificationEmail(user);

        return user;
    }

    public User registerFacebookUser(FacebookLoginDraft draft, String fullName, String phone, String dateOfBirth) {
        validateFacebookDraft(draft);
        String cleanName = fullName == null ? "" : fullName.trim();
        String cleanPhone = phone == null ? "" : phone.trim();

        if (cleanName.isEmpty()) {
            throw new IllegalArgumentException("Please enter your full name.");
        }
        if (cleanPhone.isEmpty()) {
            throw new IllegalArgumentException("Please enter your phone number.");
        }

        User user = userDAO.findOrCreateFacebookUser(
                draft.getFacebookId(),
                draft.getEmail(),
                cleanName,
                draft.getAvatarUrl(),
                cleanPhone,
                parseDateOfBirth(dateOfBirth));

        user.setStatus(UserStatus.PENDING);
        user.setEmailVerified(false);
        userDAO.update(user);

        sendVerificationEmail(user);

        return user;
    }

    private void sendVerificationEmail(User user) {
        String tokenValue = UUID.randomUUID().toString().replace("-", "");
        Date expiresAt = new Date(System.currentTimeMillis() + 24 * 60 * 60 * 1000L);

        VerificationToken verifyToken = new VerificationToken(user, tokenValue, VerificationTokenType.EMAIL_VERIFY, expiresAt);
        tokenDAO.insert(verifyToken);

        String verifyLink = "http://localhost:8080/RestaurantManagement/MainController?action=verify&token=" + tokenValue;
        EmailUtil.sendVerifyEmail(user.getEmail(), user.getFullName(), verifyLink);
    }

    public String verifyEmail(String tokenValue) {
        if (tokenValue == null || tokenValue.trim().isEmpty()) {
            return "Invalid verification link.";
        }

        VerificationToken token = tokenDAO.findValidToken(tokenValue.trim(), VerificationTokenType.EMAIL_VERIFY);
        if (token == null) {
            return "This verification link is invalid or has expired.";
        }

        User user = token.getUser();
        if (user == null) {
            return "User not found.";
        }

        user.setStatus(UserStatus.ACTIVE);
        user.setEmailVerified(true);
        userDAO.update(user);

        token.setUsedAt(new Date());
        tokenDAO.update(token);

        return null;
    }

    public FacebookLoginDraft buildFacebookLoginDraftFromAccessToken(String accessToken) {
        if (accessToken == null || accessToken.trim().isEmpty()) {
            throw new IllegalArgumentException("Facebook access token is missing.");
        }

        return toFacebookDraft(fetchFacebookUserInfo(accessToken.trim()));
    }

    public User findExistingFacebookUser(FacebookLoginDraft draft) {
        if (draft == null) {
            return null;
        }

        User user = userDAO.searchByGoogleId(toFacebookKey(draft.getFacebookId()));
        if (user == null) {
            user = userDAO.searchByEmail(draft.getEmail());
        }
        return user;
    }

    public User loginExistingFacebookUser(FacebookLoginDraft draft) {
        validateFacebookDraft(draft);
        if (findExistingFacebookUser(draft) == null) {
            throw new IllegalArgumentException("Please complete your account information first.");
        }

        User user = userDAO.findOrCreateFacebookUser(
                draft.getFacebookId(),
                draft.getEmail(),
                draft.getFullName(),
                draft.getAvatarUrl(),
                null,
                null);
        if (user.getStatus() != UserStatus.ACTIVE) {
            throw new IllegalArgumentException("Account is not active. Please verify your email first.");
        }
        return user;
    }

    private FacebookLoginDraft toFacebookDraft(FacebookProfile profile) {
        FacebookLoginDraft draft = new FacebookLoginDraft();
        draft.setFacebookId(profile.id);
        draft.setEmail(profile.email);
        draft.setFullName(profile.name);
        draft.setAvatarUrl(profile.picture);
        return draft;
    }

    private void validateFacebookDraft(FacebookLoginDraft draft) {
        if (draft == null || draft.getFacebookId() == null || draft.getFacebookId().trim().isEmpty()) {
            throw new IllegalArgumentException("Facebook account information is missing.");
        }
        if (draft.getEmail() == null || draft.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("Facebook account email is missing.");
        }
    }

    private String toFacebookKey(String facebookId) {
        return facebookId == null ? null : "facebook:" + facebookId;
    }

    private GoogleLoginDraft toDraft(GoogleProfile profile) {
        GoogleLoginDraft draft = new GoogleLoginDraft();
        draft.setGoogleId(profile.subject);
        draft.setEmail(profile.email);
        draft.setFullName(profile.name);
        draft.setAvatarUrl(profile.picture);
        return draft;
    }

    private void validateGoogleDraft(GoogleLoginDraft draft) {
        if (draft == null || draft.getGoogleId() == null || draft.getGoogleId().trim().isEmpty()) {
            throw new IllegalArgumentException("Google account information is missing.");
        }
        if (draft.getEmail() == null || draft.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("Google account email is missing.");
        }
    }

    private Date parseDateOfBirth(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return new SimpleDateFormat("yyyy-MM-dd").parse(value.trim());
        } catch (ParseException e) {
            throw new IllegalArgumentException("Date of birth is invalid.");
        }
    }

    private GoogleProfile verifyGoogleCredential(String credential) {
        try {
            String encodedToken = URLEncoder.encode(credential, StandardCharsets.UTF_8.name());
            HttpURLConnection connection = (HttpURLConnection) new URL(GOOGLE_TOKEN_INFO_URL + encodedToken).openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(7000);
            connection.setReadTimeout(7000);

            int status = connection.getResponseCode();
            String body = readResponse(connection, status);
            if (status != HttpURLConnection.HTTP_OK) {
                throw new IllegalArgumentException("Google login verification failed.");
            }

            GoogleProfile profile = parseGoogleProfile(body);
            if (!GOOGLE_CLIENT_ID.equals(profile.audience)) {
                throw new IllegalArgumentException("Google login audience is invalid.");
            }
            if (!isGoogleEmailVerified(profile.emailVerified)) {
                throw new IllegalArgumentException("Google email is not verified.");
            }
            if (profile.email == null || profile.email.trim().isEmpty()) {
                throw new IllegalArgumentException("Google account email is missing.");
            }
            return profile;
        } catch (IOException e) {
            throw new IllegalArgumentException("Cannot connect to Google login service.");
        }
    }

    private GoogleProfile verifyGoogleAccessToken(String accessToken) {
        try {
            String encodedToken = URLEncoder.encode(accessToken, StandardCharsets.UTF_8.name());
            HttpURLConnection tokenConnection = (HttpURLConnection) new URL(GOOGLE_ACCESS_TOKEN_INFO_URL + encodedToken).openConnection();
            tokenConnection.setRequestMethod("GET");
            tokenConnection.setConnectTimeout(7000);
            tokenConnection.setReadTimeout(7000);

            int tokenStatus = tokenConnection.getResponseCode();
            String tokenBody = readResponse(tokenConnection, tokenStatus);
            if (tokenStatus != HttpURLConnection.HTTP_OK) {
                throw new IllegalArgumentException("Google login verification failed.");
            }

            GoogleProfile tokenProfile = parseGoogleProfile(tokenBody);
            if (!GOOGLE_CLIENT_ID.equals(tokenProfile.audience)) {
                throw new IllegalArgumentException("Google login audience is invalid.");
            }
            if (!isGoogleEmailVerified(tokenProfile.emailVerified)) {
                throw new IllegalArgumentException("Google email is not verified.");
            }
            if (tokenProfile.email == null || tokenProfile.email.trim().isEmpty()) {
                throw new IllegalArgumentException("Google account email is missing.");
            }

            GoogleProfile userProfile = fetchGoogleUserInfo(accessToken);
            if (userProfile.email == null || userProfile.email.trim().isEmpty()) {
                userProfile.email = tokenProfile.email;
            }
            if (userProfile.subject == null || userProfile.subject.trim().isEmpty()) {
                userProfile.subject = tokenProfile.subject;
            }
            if (userProfile.emailVerified == null) {
                userProfile.emailVerified = tokenProfile.emailVerified;
            }
            if (userProfile.subject == null || userProfile.subject.trim().isEmpty()) {
                throw new IllegalArgumentException("Google account id is missing.");
            }
            return userProfile;
        } catch (IOException e) {
            throw new IllegalArgumentException("Cannot connect to Google login service.");
        }
    }

    private GoogleProfile fetchGoogleUserInfo(String accessToken) throws IOException {
        HttpURLConnection connection = (HttpURLConnection) new URL(GOOGLE_USER_INFO_URL).openConnection();
        connection.setRequestMethod("GET");
        connection.setConnectTimeout(7000);
        connection.setReadTimeout(7000);
        connection.setRequestProperty("Authorization", "Bearer " + accessToken);

        int status = connection.getResponseCode();
        String body = readResponse(connection, status);
        if (status != HttpURLConnection.HTTP_OK) {
            throw new IllegalArgumentException("Cannot read Google account profile.");
        }
        return parseGoogleProfile(body);
    }

    private FacebookProfile fetchFacebookUserInfo(String accessToken) {
        try {
            String encodedToken = URLEncoder.encode(accessToken, StandardCharsets.UTF_8.name());
            String url = FACEBOOK_USER_INFO_URL
                    + "?fields=id,name,email,picture.type(large)"
                    + "&access_token=" + encodedToken;
            HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(7000);
            connection.setReadTimeout(7000);

            int status = connection.getResponseCode();
            String body = readResponse(connection, status);
            if (status != HttpURLConnection.HTTP_OK) {
                throw new IllegalArgumentException("Facebook login verification failed.");
            }

            FacebookProfile profile = parseFacebookProfile(body);
            if (profile.id == null || profile.id.trim().isEmpty()) {
                throw new IllegalArgumentException("Facebook account id is missing.");
            }
            if (profile.email == null || profile.email.trim().isEmpty()) {
                throw new IllegalArgumentException("Facebook account email is missing. Please allow email permission.");
            }
            return profile;
        } catch (IOException e) {
            throw new IllegalArgumentException("Cannot connect to Facebook login service.");
        }
    }

    private String readResponse(HttpURLConnection connection, int status) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(
                status >= 200 && status < 300 ? connection.getInputStream() : connection.getErrorStream(),
                StandardCharsets.UTF_8));
        StringBuilder builder = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            builder.append(line);
        }
        reader.close();
        return builder.toString();
    }

    private GoogleProfile parseGoogleProfile(String json) {
        GoogleProfile profile = new GoogleProfile();
        profile.subject = extractJsonValue(json, "sub");
        if (profile.subject == null) {
            profile.subject = extractJsonValue(json, "user_id");
        }
        profile.email = extractJsonValue(json, "email");
        profile.emailVerified = extractJsonValue(json, "email_verified");
        if (profile.emailVerified == null) {
            profile.emailVerified = extractJsonValue(json, "verified_email");
        }
        profile.name = extractJsonValue(json, "name");
        profile.picture = extractJsonValue(json, "picture");
        profile.audience = extractJsonValue(json, "aud");
        if (profile.audience == null) {
            profile.audience = extractJsonValue(json, "audience");
        }
        if (profile.audience == null) {
            profile.audience = extractJsonValue(json, "issued_to");
        }
        return profile;
    }

    private FacebookProfile parseFacebookProfile(String json) {
        FacebookProfile profile = new FacebookProfile();
        profile.id = extractJsonValue(json, "id");
        profile.email = extractJsonValue(json, "email");
        profile.name = extractJsonValue(json, "name");
        profile.picture = extractJsonValue(json, "url");
        return profile;
    }

    private String extractJsonValue(String json, String key) {
        Pattern pattern = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*(?:\"((?:\\\\.|[^\"])*)\"|([^,}\\s]+))");
        Matcher matcher = pattern.matcher(json);
        if (!matcher.find()) {
            return null;
        }
        String value = matcher.group(1) != null ? matcher.group(1) : matcher.group(2);
        return decodeJsonString(value);
    }

    private boolean isGoogleEmailVerified(String value) {
        return "true".equalsIgnoreCase(value) || "1".equals(value);
    }

    private String decodeJsonString(String value) {
        if (value == null) {
            return null;
        }

        StringBuilder decoded = new StringBuilder();
        for (int i = 0; i < value.length(); i++) {
            char current = value.charAt(i);
            if (current != '\\' || i + 1 >= value.length()) {
                decoded.append(current);
                continue;
            }

            char escaped = value.charAt(++i);
            switch (escaped) {
                case '"':
                    decoded.append('"');
                    break;
                case '\\':
                    decoded.append('\\');
                    break;
                case '/':
                    decoded.append('/');
                    break;
                case 'b':
                    decoded.append('\b');
                    break;
                case 'f':
                    decoded.append('\f');
                    break;
                case 'n':
                    decoded.append('\n');
                    break;
                case 'r':
                    decoded.append('\r');
                    break;
                case 't':
                    decoded.append('\t');
                    break;
                case 'u':
                    if (i + 4 < value.length()) {
                        try {
                            decoded.append((char) Integer.parseInt(value.substring(i + 1, i + 5), 16));
                            i += 4;
                        } catch (NumberFormatException e) {
                            decoded.append("\\u");
                        }
                    } else {
                        decoded.append("\\u");
                    }
                    break;
                default:
                    decoded.append(escaped);
                    break;
            }
        }
        return decoded.toString();
    }

    private static class GoogleProfile {
        private String subject;
        private String email;
        private String emailVerified;
        private String name;
        private String picture;
        private String audience;
    }

    private static class FacebookProfile {
        private String id;
        private String email;
        private String name;
        private String picture;
    }
}

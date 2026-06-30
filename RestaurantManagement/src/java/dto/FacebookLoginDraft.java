package dto;

import java.io.Serializable;

public class FacebookLoginDraft implements Serializable {
    private String facebookId;
    private String email;
    private String fullName;
    private String avatarUrl;

    public String getFacebookId() { return facebookId; }
    public void setFacebookId(String facebookId) { this.facebookId = facebookId; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
}

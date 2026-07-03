package entity;

import enums.VerificationTokenType;
import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

@Entity
@Table(name = "verification_token")
public class VerificationToken implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "token", nullable = false, unique = true, length = 255)
    private String token;

    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false, length = 20)
    private VerificationTokenType type;

    @Column(name = "expires_at", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date expiresAt;

    @Column(name = "used_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date usedAt;

    public VerificationToken() {
    }

    public VerificationToken(User user, String token, VerificationTokenType type, Date expiresAt) {
        this.user = user;
        this.token = token;
        this.type = type;
        this.expiresAt = expiresAt;
    }

    public boolean isExpired() {
        return new Date().after(expiresAt);
    }

    public boolean isValid() {
        return usedAt == null && !isExpired();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }
    public VerificationTokenType getType() { return type; }
    public void setType(VerificationTokenType type) { this.type = type; }
    public Date getExpiresAt() { return expiresAt; }
    public void setExpiresAt(Date expiresAt) { this.expiresAt = expiresAt; }
    public Date getUsedAt() { return usedAt; }
    public void setUsedAt(Date usedAt) { this.usedAt = usedAt; }
}

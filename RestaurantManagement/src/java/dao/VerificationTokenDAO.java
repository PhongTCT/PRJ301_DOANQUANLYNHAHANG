package dao;

import entity.VerificationToken;

public class VerificationTokenDAO extends AbstractDAO<VerificationToken, Long> {
    public VerificationTokenDAO() { super(VerificationToken.class); }
}

package service;

import dao.UserDAO;
import entity.User;
import enums.UserStatus;
import util.BCryptUtil;

public class AuthService {
    private final UserDAO userDAO = new UserDAO();

    public User login(String email, String password) {
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Please enter email and password.");
        }
        User user = userDAO.searchByEmail(email.trim());
        if (user == null) {
            throw new IllegalArgumentException("Account does not exist.");
        }
        if (user.getStatus() != UserStatus.ACTIVE) {
            throw new IllegalArgumentException("Account is not active.");
        }
        if (!BCryptUtil.checkPassword(password, user.getPassword())) {
            throw new IllegalArgumentException("Incorrect password.");
        }
        return user;
    }
}

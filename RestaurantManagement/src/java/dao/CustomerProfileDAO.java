package dao;

import entity.CustomerProfile;

public class CustomerProfileDAO extends AbstractDAO<CustomerProfile, Long> {
    public CustomerProfileDAO() { super(CustomerProfile.class); }
}

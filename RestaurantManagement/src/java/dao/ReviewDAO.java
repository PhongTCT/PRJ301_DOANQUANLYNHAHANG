package dao;

import entity.Review;

public class ReviewDAO extends AbstractDAO<Review, Long> {
    public ReviewDAO() { super(Review.class); }
}

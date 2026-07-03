DECLARE @sig_orig INT, @sig_disc INT;
DECLARE @ess_orig INT, @ess_disc INT;

SELECT @sig_orig = original_price, @sig_disc = discounted_price FROM menu_set WHERE set_name = 'Signature Set';
SELECT @ess_orig = original_price, @ess_disc = discounted_price FROM menu_set WHERE set_name = 'Essence Set';

UPDATE menu_set SET original_price = @ess_orig, discounted_price = @ess_disc WHERE set_name = 'Signature Set';
UPDATE menu_set SET original_price = @sig_orig, discounted_price = @sig_disc WHERE set_name = 'Essence Set';

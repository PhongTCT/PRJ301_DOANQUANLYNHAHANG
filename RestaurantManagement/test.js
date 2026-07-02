let cart = {
    menu: {},
    addon: {},
    combo: {}
};

function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN').format(amount) + 'd';
}

function updateQty(type, id, delta) {
    if (cart[type][id]) {
        cart[type][id].qty += delta;
        if (cart[type][id].qty <= 0) {
            delete cart[type][id];
        }
        renderCart();
    }
}

let surchargePercent = 0;
let list = { children: [], appendChild: function(){} };
let emptyMsg = { style: { display: '' } };

function renderCart() {
    let total = 0;
    let hasItems = false;
    
    // clear list except empty message
    const types = ['combo', 'menu', 'addon'];
    types.forEach(t => {
        for (let id in cart[t]) {
            hasItems = true;
            let item = cart[t][id];
            let lineTotal = item.price * item.qty;
            total += lineTotal;
        }
    });
    console.log("Rendered cart! Total: " + total + ", hasItems: " + hasItems);
}

function addToCart(type, id, name, price) {
    if (type === 'menu') {
        let hasCombo = Object.keys(cart['combo']).length > 0;
        if (!hasCombo) {
            console.log("No combo selected");
            return;
        }
    }

    if (!cart[type][id]) {
        cart[type][id] = { name: name, price: price, qty: 1 };
    } else {
        cart[type][id].qty++;
    }
    renderCart();
}

addToCart('combo', 1, 'Seafood Set', 3999000);

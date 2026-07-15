const fs = require('fs');
let content = fs.readFileSync('d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/common/booking-step4.jsp', 'utf8');

const replacements = [
    [/XA.c nh.-n thA'ng tin .\?.*t bA.n/g, "<fmt:message key='booking.step4.header.title'/>"],
    [/Vui lA.ng ki.m tra l.i thA'ng tin tr.>c khi hoAn t.t/g, "<fmt:message key='booking.step4.header.desc'/>"],
    [/ThA'ng tin .\.*t bAn/g, "<fmt:message key='booking.step4.info.title'/>"],
    [/NgA.y nh.-n bA.n/g, "<fmt:message key='booking.step4.info.date'/>"],
    [/Gi.\? .\.*n/g, "<fmt:message key='booking.step4.info.time'/>"],
    [/KhA.ch hA.ng/g, "<fmt:message key='booking.step4.info.customer'/>"],
    [/S.\ l.ng/g, "<fmt:message key='booking.step4.info.guests'/>"],
    [/ng.\?i l.>n/g, "<fmt:message key='booking.step4.info.adults'/>"],
    [/tr. em/g, "<fmt:message key='booking.step4.info.children'/>"],
    [/TA3m t._t thanh toA.n/g, "<fmt:message key='booking.step4.summary.title'/>"],
    [/T.m tA-nh bA.n, mA3n .n vA. d.\<ch v./g, "<fmt:message key='booking.step4.summary.subtotal'/>"],
    [/Ph. thu ngA.y l../g, "<fmt:message key='booking.step4.summary.surcharge'/>"],
    [/T. ng tr.>c .u .\A.i/g, "<fmt:message key='booking.step4.summary.total'/>"],
    [/Voucher gi.m t. ng bill/g, "<fmt:message key='booking.step4.voucher.title'/>"],
    [/KhA'ng dA1ng voucher/g, "<fmt:message key='booking.step4.voucher.none'/>"],
    [/M.-i voucher ch.% dA1ng m.Tt l. n cho m.-i tAi kho.n. L.t dA1ng s. .\.*c l.u cA1ng invoice./g, "<fmt:message key='booking.step4.voucher.note'/>"],
    [/.\?i.m tAch l.cy/g, "<fmt:message key='booking.step4.points.title'/>"],
    [/1 .\i.m = 1.000.\ gi.m tr.c ti.p vAo hA3a .\.*n./g, "<fmt:message key='booking.step4.points.note'/>"],
    [/Ph.ng th.cc thanh toA.n/g, "<fmt:message key='booking.step4.payment.title'/>"],
    [/Chuy.n sang c. ng VNPay .\.* thanh toA.n ngay./g, "<fmt:message key='booking.step4.payment.vnpay.desc'/>"],
    [/.\?ang phA.t tri.n./g, "<fmt:message key='booking.step4.payment.momo.desc'/>"],
    [/Ti.n m.t t.i qu. y/g, "<fmt:message key='booking.step4.payment.cash'/>"],
    [/Thanh toA.n ti.n m.t ho.c qu.t th. khi .\.*n nhA. hA.ng./g, "<fmt:message key='booking.step4.payment.cash.desc'/>"],
    [/VNPay s. t. c.p nh.t hA3a .\.*n khi thanh toA.n thAnh cA'ng. Ti.?n m.t .\.*c staff\/admin xA.c nh.n t.i qu. y./g, "<fmt:message key='booking.step4.payment.note'/>"],
    [/Voucher vA .\i.m .\.*c ki.m tra l.i t.i th.\?i .\i.m xA.c nh.n .\.* .\.*m b.o s.\ l.ng cA.n .\A.ng. N.u voucher .\A. h.t l.t ho.c tAi kho.n .\A. dA1ng voucher .\A3, h. th.\
g s. bA.o l.-i vA gi._ b.n .Y b.>c nAy./g, "<fmt:message key='booking.step4.notice'/>"],
    [/Quay l.i/g, "<fmt:message key='booking.step4.btn.back'/>"],
    [/XA.c nh.n .\?.*t BAn/g, "<fmt:message key='booking.step4.btn.confirm'/>"],
    [/XA.c nh.-n/g, "<fmt:message key='booking.step4.title'/>"]
];

replacements.forEach(([pattern, replacement]) => {
    content = content.replace(pattern, replacement);
});

fs.writeFileSync('d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/common/booking-step4.jsp', content, 'utf8');

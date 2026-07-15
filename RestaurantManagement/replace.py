import re

with open('d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/common/booking-step4.jsp', 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()

replacements = {
    r"XA.c nh.-n thA'ng tin .\?.*t bA.n": "<fmt:message key='booking.step4.header.title'/>",
    r"Vui lA.ng ki.m tra l.i thA'ng tin tr.>c khi hoAn t.t": "<fmt:message key='booking.step4.header.desc'/>",
    r"ThA'ng tin .\.*t bAn": "<fmt:message key='booking.step4.info.title'/>",
    r"NgA.y nh.-n bA.n": "<fmt:message key='booking.step4.info.date'/>",
    r"Gi.\? .\.*n": "<fmt:message key='booking.step4.info.time'/>",
    r"KhA.ch hA.ng": "<fmt:message key='booking.step4.info.customer'/>",
    r"S.\ l.ng": "<fmt:message key='booking.step4.info.guests'/>",
    r"ng.\?i l.>n": "<fmt:message key='booking.step4.info.adults'/>",
    r"tr. em": "<fmt:message key='booking.step4.info.children'/>",
    r"TA3m t._t thanh toA.n": "<fmt:message key='booking.step4.summary.title'/>",
    r"T.m tA-nh bA.n, mA3n .n vA. d.\<ch v.": "<fmt:message key='booking.step4.summary.subtotal'/>",
    r"Ph. thu ngA.y l..": "<fmt:message key='booking.step4.summary.surcharge'/>",
    r"T. ng tr.>c .u .\A.i": "<fmt:message key='booking.step4.summary.total'/>",
    r"Voucher gi.m t. ng bill": "<fmt:message key='booking.step4.voucher.title'/>",
    r"KhA'ng dA1ng voucher": "<fmt:message key='booking.step4.voucher.none'/>",
    r"M.-i voucher ch.% dA1ng m.Tt l. n cho m.-i tAi kho.n. L.t dA1ng s. .\.*c l.u cA1ng invoice.": "<fmt:message key='booking.step4.voucher.note'/>",
    r".\?i.m tAch l.cy": "<fmt:message key='booking.step4.points.title'/>",
    r"1 .\i.m = 1.000.\ gi.m tr.c ti.p vAo hA3a .\.*n.": "<fmt:message key='booking.step4.points.note'/>",
    r"Ph.ng th.cc thanh toA.n": "<fmt:message key='booking.step4.payment.title'/>",
    r"Chuy.n sang c. ng VNPay .\.* thanh toA.n ngay.": "<fmt:message key='booking.step4.payment.vnpay.desc'/>",
    r".\?ang phA.t tri.n.": "<fmt:message key='booking.step4.payment.momo.desc'/>",
    r"Ti.n m.t t.i qu. y": "<fmt:message key='booking.step4.payment.cash'/>",
    r"Thanh toA.n ti.n m.t ho.c qu.t th. khi .\.*n nhA. hA.ng.": "<fmt:message key='booking.step4.payment.cash.desc'/>",
    r"VNPay s. t. c.p nh.t hA3a .\.*n khi thanh toA.n thAnh cA'ng. Ti.?n m.t .\.*c staff/admin xA.c nh.n t.i qu. y.": "<fmt:message key='booking.step4.payment.note'/>",
    r"Voucher vA .\i.m .\.*c ki.m tra l.i t.i th.?i .\i.m xA.c nh.n .\.* .\.*m b.o s.\ l.ng cA.n .\A.ng. N.u voucher .\A. h.t l.t ho.c tAi kho.n .\A. dA1ng voucher .\A3, h. th.\
g s. bA.o l.-i vA gi._ b.n .Y b.>c nAy.": "<fmt:message key='booking.step4.notice'/>",
    r"Quay l.i": "<fmt:message key='booking.step4.btn.back'/>",
    r"XA.c nh.n .\?.*t BAn": "<fmt:message key='booking.step4.btn.confirm'/>",
    r"XA.c nh.-n": "<fmt:message key='booking.step4.title'/>",
}

for k, v in replacements.items():
    content = re.sub(k, v, content)

with open('d:/Github_Projects/PRJ301_DOANQUANLYNHAHANG/RestaurantManagement/web/common/booking-step4.jsp', 'w', encoding='utf-8') as f:
    f.write(content)

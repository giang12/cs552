lbi r4, 1
lbi r5, 2
sle r6, r4, r5
beqz r6, .label1
nop
.label1
nop
halt
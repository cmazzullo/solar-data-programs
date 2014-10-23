;; This is a top-level script to select points and compute
;; the velocity of the material there.

;; !path = !path + '/swd4/Users/EIS/art/artjim'
;; !path = !path + '/swd4/Users/EIS/cmazzullo/solar-data-programs'

fname = 'init.txt'
init_data = read_init_file(fname)

file = init_data.l1_file
print, 'file = ', file
;; wvls = init_data.wvls
windowNs = init_data.windowNs
;; lit_wvls = init_data.lit_wvls
;; box_size = init_data.box_size
print, 'Using file', file
dws = all_window_data(file, windowNs)

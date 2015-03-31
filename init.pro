
folder = '/swd4/Users/EIS/art/artchris/'
basename = 'eis_l1_20140318_182304.fits'
;basename = "eis_l1_20140815_235312.fits"
file = folder + basename

;windowNs = [0, 3, 6, 8, 9, 21, 23, 24]
windowNs = [0, 1, 2, 3]
lit_wvls = [185.213, 186.880, 195.119, 284.160]

do_abswl = 0                ; Whether or not to add abswl shift
abswl_window = 2
;; vel_corr = .026 ;; absolute wavelength shift - right now it's factored in already!
display_window = 2

;; ESTIMATES:
;; Format:
;; [[windowN, intensity, literature wavelength, std. dev.], [window2, etc...]]
;; estimates = [[21, 2500, 276.579, 0.025], [21, 2500, 276.153, 0.025], [100, 0, 0, 0], [100, 0, 0, 0]]

;; BOX SIZE for point selection
box_size = 3

;; LITERATURE WAVELENGTHS
;; These shouldn't change very much

;; lit_wvls = dblarr(25) ; wavelengths according to the literature

;; lit_wvls[0] = 180.401           ; Fe XI
;; lit_wvls[1] = 182.859           ; Ca XV
;; lit_wvls[2] = 184.536           ; Fe X
;; lit_wvls[3] = 185.213           ; Fe VIII
;; lit_wvls[4] = 186.880           ; Fe XII
;; lit_wvls[5] = 188.216           ; Fe XI
;; lit_wvls[6] = 192.394           ; Fe XII (?)
;; lit_wvls[7] = 193.874
;; lit_wvls[8] = 195.119           ; Fe XII
;; lit_wvls[9] = 197.858           ; Fe XIII (fixed)
;; lit_wvls[10] = 200.972
;; lit_wvls[11] = 202.044
;; lit_wvls[12] = 203.826
;; lit_wvls[13] = 208.500 ; There doesn't seem to be a Ca XVI line here
;; lit_wvls[14] = 255.000 ; Couldnt' find an Fe XXIV line on the table anywhere
;; lit_wvls[15] = 256.686
;; lit_wvls[16] = 258.375
;; lit_wvls[17] = 262.948
;; lit_wvls[18] = 264.233
;; lit_wvls[19] = 270.519
;; lit_wvls[20] = 275.352
;; lit_wvls[21] = 276.153 ; Two lines: Mg VII @ 276.153, Mg V @ 276.579
;; lit_wvls[22] = 278.402
;; lit_wvls[23] = 280.737          ; Mg VII
;; lit_wvls[24] = 284.160          ; Fe XV



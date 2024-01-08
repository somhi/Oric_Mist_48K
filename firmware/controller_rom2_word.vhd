library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller_rom2 is
generic	(
	ADDR_WIDTH : integer := 8; -- ROM's address width (words, not bytes)
	COL_WIDTH  : integer := 8;  -- Column width (8bit -> byte)
	NB_COL     : integer := 4  -- Number of columns in memory
	);
port (
	clk : in std_logic;
	reset_n : in std_logic := '1';
	addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
	q : out std_logic_vector(31 downto 0);
	-- Allow writes - defaults supplied to simplify projects that don't need to write.
	d : in std_logic_vector(31 downto 0) := X"00000000";
	we : in std_logic := '0';
	bytesel : in std_logic_vector(3 downto 0) := "1111"
);
end entity;

architecture arch of controller_rom2 is

-- type word_t is std_logic_vector(31 downto 0);
type ram_type is array (0 to 2 ** ADDR_WIDTH - 1) of std_logic_vector(NB_COL * COL_WIDTH - 1 downto 0);

signal ram : ram_type :=
(

     0 => x"047f7f00",
     1 => x"00787c04",
     2 => x"3d000000",
     3 => x"0000407d",
     4 => x"80808000",
     5 => x"00007dfd",
     6 => x"107f7f00",
     7 => x"00446c38",
     8 => x"3f000000",
     9 => x"0000407f",
    10 => x"180c7c7c",
    11 => x"00787c0c",
    12 => x"047c7c00",
    13 => x"00787c04",
    14 => x"447c3800",
    15 => x"00387c44",
    16 => x"24fcfc00",
    17 => x"00183c24",
    18 => x"243c1800",
    19 => x"00fcfc24",
    20 => x"047c7c00",
    21 => x"00080c04",
    22 => x"545c4800",
    23 => x"00207454",
    24 => x"7f3f0400",
    25 => x"00004444",
    26 => x"407c3c00",
    27 => x"007c7c40",
    28 => x"603c1c00",
    29 => x"001c3c60",
    30 => x"30607c3c",
    31 => x"003c7c60",
    32 => x"10386c44",
    33 => x"00446c38",
    34 => x"e0bc1c00",
    35 => x"001c3c60",
    36 => x"74644400",
    37 => x"00444c5c",
    38 => x"3e080800",
    39 => x"00414177",
    40 => x"7f000000",
    41 => x"0000007f",
    42 => x"77414100",
    43 => x"0008083e",
    44 => x"03010102",
    45 => x"00010202",
    46 => x"7f7f7f7f",
    47 => x"007f7f7f",
    48 => x"1c1c0808",
    49 => x"7f7f3e3e",
    50 => x"3e3e7f7f",
    51 => x"08081c1c",
    52 => x"7c181000",
    53 => x"0010187c",
    54 => x"7c301000",
    55 => x"0010307c",
    56 => x"60603010",
    57 => x"00061e78",
    58 => x"183c6642",
    59 => x"0042663c",
    60 => x"c26a3878",
    61 => x"00386cc6",
    62 => x"60000060",
    63 => x"00600000",
    64 => x"5c5b5e0e",
    65 => x"711e0e5d",
    66 => x"faf7c24c",
    67 => x"4bc04dbf",
    68 => x"ab741ec0",
    69 => x"c487c702",
    70 => x"78c048a6",
    71 => x"a6c487c5",
    72 => x"c478c148",
    73 => x"49731e66",
    74 => x"c887dfee",
    75 => x"49e0c086",
    76 => x"c487efef",
    77 => x"496a4aa5",
    78 => x"f187f0f0",
    79 => x"85cb87c6",
    80 => x"b7c883c1",
    81 => x"c7ff04ab",
    82 => x"4d262687",
    83 => x"4b264c26",
    84 => x"711e4f26",
    85 => x"fef7c24a",
    86 => x"fef7c25a",
    87 => x"4978c748",
    88 => x"2687ddfe",
    89 => x"1e731e4f",
    90 => x"b7c04a71",
    91 => x"87d303aa",
    92 => x"bff2d5c2",
    93 => x"c187c405",
    94 => x"c087c24b",
    95 => x"f6d5c24b",
    96 => x"c287c45b",
    97 => x"c25af6d5",
    98 => x"4abff2d5",
    99 => x"c0c19ac1",
   100 => x"e8ec49a2",
   101 => x"dad5c287",
   102 => x"d5c249bf",
   103 => x"fcb1bff2",
   104 => x"fe787148",
   105 => x"711e87e8",
   106 => x"1e66c44a",
   107 => x"f6e94972",
   108 => x"4f262687",
   109 => x"f2d5c21e",
   110 => x"d0e649bf",
   111 => x"f2f7c287",
   112 => x"78bfe848",
   113 => x"48eef7c2",
   114 => x"c278bfec",
   115 => x"4abff2f7",
   116 => x"99ffc349",
   117 => x"722ab7c8",
   118 => x"c2b07148",
   119 => x"2658faf7",
   120 => x"5b5e0e4f",
   121 => x"710e5d5c",
   122 => x"87c8ff4b",
   123 => x"48edf7c2",
   124 => x"497350c0",
   125 => x"7087f6e5",
   126 => x"9cc24c49",
   127 => x"cd49eecb",
   128 => x"497087f8",
   129 => x"edf7c24d",
   130 => x"c105bf97",
   131 => x"66d087e2",
   132 => x"f6f7c249",
   133 => x"d60599bf",
   134 => x"4966d487",
   135 => x"bfeef7c2",
   136 => x"87cb0599",
   137 => x"c4e54973",
   138 => x"02987087",
   139 => x"c187c1c1",
   140 => x"87c0fe4c",
   141 => x"cdcd4975",
   142 => x"02987087",
   143 => x"f7c287c6",
   144 => x"50c148ed",
   145 => x"97edf7c2",
   146 => x"e3c005bf",
   147 => x"f6f7c287",
   148 => x"66d049bf",
   149 => x"d6ff0599",
   150 => x"eef7c287",
   151 => x"66d449bf",
   152 => x"caff0599",
   153 => x"e4497387",
   154 => x"987087c3",
   155 => x"87fffe05",
   156 => x"d5fb4874",
   157 => x"5b5e0e87",
   158 => x"f80e5d5c",
   159 => x"4c4dc086",
   160 => x"c47ebfec",
   161 => x"f7c248a6",
   162 => x"c078bffa",
   163 => x"f7c11e1e",
   164 => x"87cdfd49",
   165 => x"987086c8",
   166 => x"87f3c002",
   167 => x"bfdad5c2",
   168 => x"c187c405",
   169 => x"c087c27e",
   170 => x"dad5c27e",
   171 => x"ca786e48",
   172 => x"66c41efc",
   173 => x"c487c902",
   174 => x"d3c248a6",
   175 => x"87c778f1",
   176 => x"c248a6c4",
   177 => x"c478fcd3",
   178 => x"fbc84966",
   179 => x"c186c487",
   180 => x"c71ec01e",
   181 => x"87c9fc49",
   182 => x"987086c8",
   183 => x"ff87cd02",
   184 => x"87c1fa49",
   185 => x"e249dac1",
   186 => x"4dc187c3",
   187 => x"97edf7c2",
   188 => x"87c302bf",
   189 => x"c287cdd7",
   190 => x"4bbff2f7",
   191 => x"bff2d5c2",
   192 => x"87e1c105",
   193 => x"bfdad5c2",
   194 => x"87f0c002",
   195 => x"c848a6c4",
   196 => x"c278c0c0",
   197 => x"6e7eded5",
   198 => x"6e49bf97",
   199 => x"7080c148",
   200 => x"c8e1717e",
   201 => x"02987087",
   202 => x"66c487c3",
   203 => x"4866c4b3",
   204 => x"c828b7c1",
   205 => x"987058a6",
   206 => x"87dbff05",
   207 => x"e049fdc3",
   208 => x"fac387eb",
   209 => x"87e5e049",
   210 => x"ffc34973",
   211 => x"c01e7199",
   212 => x"87d2f949",
   213 => x"b7c84973",
   214 => x"c11e7129",
   215 => x"87c6f949",
   216 => x"c7c686c8",
   217 => x"f6f7c287",
   218 => x"029b4bbf",
   219 => x"d5c287df",
   220 => x"c849bfee",
   221 => x"987087d0",
   222 => x"87c4c005",
   223 => x"87d34bc0",
   224 => x"c749e0c2",
   225 => x"d5c287f4",
   226 => x"c6c058f2",
   227 => x"eed5c287",
   228 => x"7378c048",
   229 => x"0599c249",
   230 => x"c387cfc0",
   231 => x"dfff49eb",
   232 => x"497087cb",
   233 => x"c00299c2",
   234 => x"4cfb87c2",
   235 => x"99c14973",
   236 => x"87cfc005",
   237 => x"ff49f4c3",
   238 => x"7087f2de",
   239 => x"0299c249",
   240 => x"fa87c2c0",
   241 => x"c849734c",
   242 => x"cfc00599",
   243 => x"49f5c387",
   244 => x"87d9deff",
   245 => x"99c24970",
   246 => x"87d6c002",
   247 => x"bffef7c2",
   248 => x"87cac002",
   249 => x"c288c148",
   250 => x"c058c2f8",
   251 => x"4cff87c2",
   252 => x"49734dc1",
   253 => x"c00599c4",
   254 => x"f2c387cf",
   255 => x"ecddff49",
   256 => x"c2497087",
   257 => x"dcc00299",
   258 => x"fef7c287",
   259 => x"c7487ebf",
   260 => x"c003a8b7",
   261 => x"486e87cb",
   262 => x"f8c280c1",
   263 => x"c2c058c2",
   264 => x"c14cfe87",
   265 => x"49fdc34d",
   266 => x"87c1ddff",
   267 => x"99c24970",
   268 => x"87d5c002",
   269 => x"bffef7c2",
   270 => x"87c9c002",
   271 => x"48fef7c2",
   272 => x"c2c078c0",
   273 => x"c14cfd87",
   274 => x"49fac34d",
   275 => x"87dddcff",
   276 => x"99c24970",
   277 => x"87d9c002",
   278 => x"bffef7c2",
   279 => x"a8b7c748",
   280 => x"87c9c003",
   281 => x"48fef7c2",
   282 => x"c2c078c7",
   283 => x"c14cfc87",
   284 => x"acb7c04d",
   285 => x"87d5c003",
   286 => x"c14866c4",
   287 => x"7e7080d8",
   288 => x"c002bf6e",
   289 => x"bf6e87c7",
   290 => x"7349744b",
   291 => x"c31ec00f",
   292 => x"dac11ef0",
   293 => x"87c9f549",
   294 => x"987086c8",
   295 => x"87d9c002",
   296 => x"bffef7c2",
   297 => x"cb496e7e",
   298 => x"4a66c491",
   299 => x"026a8271",
   300 => x"6a87c6c0",
   301 => x"73496e4b",
   302 => x"029d750f",
   303 => x"c287c8c0",
   304 => x"49bffef7",
   305 => x"c287f9f0",
   306 => x"02bff6d5",
   307 => x"4987ddc0",
   308 => x"7087f3c2",
   309 => x"d3c00298",
   310 => x"fef7c287",
   311 => x"dff049bf",
   312 => x"f149c087",
   313 => x"d5c287ff",
   314 => x"78c048f6",
   315 => x"d9f18ef8",
   316 => x"796f4a87",
   317 => x"7379656b",
   318 => x"006e6f20",
   319 => x"6b796f4a",
   320 => x"20737965",
   321 => x"0066666f",
   322 => x"5c5b5e0e",
   323 => x"711e0e5d",
   324 => x"faf7c24c",
   325 => x"cdc149bf",
   326 => x"d1c14da1",
   327 => x"747e6981",
   328 => x"87cf029c",
   329 => x"744ba5c4",
   330 => x"faf7c27b",
   331 => x"e1f049bf",
   332 => x"747b6e87",
   333 => x"87c4059c",
   334 => x"87c24bc0",
   335 => x"49734bc1",
   336 => x"d487e2f0",
   337 => x"87c80266",
   338 => x"87eec049",
   339 => x"87c24a70",
   340 => x"d5c24ac0",
   341 => x"ef265afa",
   342 => x"000087f0",
   343 => x"12580000",
   344 => x"1b1d1411",
   345 => x"595a231c",
   346 => x"f2f59491",
   347 => x"0000f4eb",
   348 => x"00000000",
   349 => x"00000000",
   350 => x"711e0000",
   351 => x"bfc8ff4a",
   352 => x"48a17249",
   353 => x"ff1e4f26",
   354 => x"fe89bfc8",
   355 => x"c0c0c0c0",
   356 => x"c401a9c0",
   357 => x"c24ac087",
   358 => x"724ac187",
   359 => x"0e4f2648",
   360 => x"5d5c5b5e",
   361 => x"ff4b710e",
   362 => x"66d04cd4",
   363 => x"d678c048",
   364 => x"f8d8ff49",
   365 => x"7cffc387",
   366 => x"ffc3496c",
   367 => x"494d7199",
   368 => x"c199f0c3",
   369 => x"cb05a9e0",
   370 => x"7cffc387",
   371 => x"98c3486c",
   372 => x"780866d0",
   373 => x"6c7cffc3",
   374 => x"31c8494a",
   375 => x"6c7cffc3",
   376 => x"72b2714a",
   377 => x"c331c849",
   378 => x"4a6c7cff",
   379 => x"4972b271",
   380 => x"ffc331c8",
   381 => x"714a6c7c",
   382 => x"48d0ffb2",
   383 => x"7378e0c0",
   384 => x"87c2029b",
   385 => x"48757b72",
   386 => x"4c264d26",
   387 => x"4f264b26",
   388 => x"0e4f261e",
   389 => x"0e5c5b5e",
   390 => x"1e7686f8",
   391 => x"fd49a6c8",
   392 => x"86c487fd",
   393 => x"486e4b70",
   394 => x"c303a8c2",
   395 => x"4a7387c6",
   396 => x"c19af0c3",
   397 => x"c702aad0",
   398 => x"aae0c187",
   399 => x"87f4c205",
   400 => x"99c84973",
   401 => x"ff87c302",
   402 => x"4c7387c6",
   403 => x"acc29cc3",
   404 => x"87cdc105",
   405 => x"c94966c4",
   406 => x"c41e7131",
   407 => x"92d44a66",
   408 => x"49c2f8c2",
   409 => x"cdfe8172",
   410 => x"66c487c5",
   411 => x"e3c01e49",
   412 => x"ddd6ff49",
   413 => x"ff49d887",
   414 => x"c887f2d5",
   415 => x"e6c21ec0",
   416 => x"e9fd49f2",
   417 => x"d0ff87d5",
   418 => x"78e0c048",
   419 => x"1ef2e6c2",
   420 => x"d44a66d0",
   421 => x"c2f8c292",
   422 => x"fe817249",
   423 => x"d087cdcb",
   424 => x"05acc186",
   425 => x"c487cdc1",
   426 => x"31c94966",
   427 => x"66c41e71",
   428 => x"c292d44a",
   429 => x"7249c2f8",
   430 => x"f2cbfe81",
   431 => x"f2e6c287",
   432 => x"4a66c81e",
   433 => x"f8c292d4",
   434 => x"817249c2",
   435 => x"87d9c9fe",
   436 => x"1e4966c8",
   437 => x"ff49e3c0",
   438 => x"d787f7d4",
   439 => x"ccd4ff49",
   440 => x"1ec0c887",
   441 => x"49f2e6c2",
   442 => x"87d9e7fd",
   443 => x"d0ff86d0",
   444 => x"78e0c048",
   445 => x"d1fc8ef8",
   446 => x"5b5e0e87",
   447 => x"1e0e5d5c",
   448 => x"d4ff4d71",
   449 => x"7e66d44c",
   450 => x"a8b7c348",
   451 => x"c087c506",
   452 => x"87e2c148",
   453 => x"d9fe4975",
   454 => x"1e7587e6",
   455 => x"d44b66c4",
   456 => x"c2f8c293",
   457 => x"fe497383",
   458 => x"c887e2c4",
   459 => x"ff4b6b83",
   460 => x"e1c848d0",
   461 => x"737cdd78",
   462 => x"99ffc349",
   463 => x"49737c71",
   464 => x"c329b7c8",
   465 => x"7c7199ff",
   466 => x"b7d04973",
   467 => x"99ffc329",
   468 => x"49737c71",
   469 => x"7129b7d8",
   470 => x"7c7cc07c",
   471 => x"7c7c7c7c",
   472 => x"7c7c7c7c",
   473 => x"e0c07c7c",
   474 => x"1e66c478",
   475 => x"d2ff49dc",
   476 => x"86c887e0",
   477 => x"fa264873",
   478 => x"5e0e87ce",
   479 => x"0e5d5c5b",
   480 => x"ff7e711e",
   481 => x"1e6e4bd4",
   482 => x"49eaf8c2",
   483 => x"87fdc2fe",
   484 => x"4d7086c4",
   485 => x"c3c3029d",
   486 => x"f2f8c287",
   487 => x"496e4cbf",
   488 => x"87dcd7fe",
   489 => x"c848d0ff",
   490 => x"d6c178c5",
   491 => x"154ac07b",
   492 => x"c082c17b",
   493 => x"04aab7e0",
   494 => x"d0ff87f5",
   495 => x"c878c448",
   496 => x"d3c178c5",
   497 => x"c47bc17b",
   498 => x"029c7478",
   499 => x"c287fcc1",
   500 => x"c87ef2e6",
   501 => x"c08c4dc0",
   502 => x"c603acb7",
   503 => x"a4c0c887",
   504 => x"c24cc04d",
   505 => x"bf97e3f3",
   506 => x"0299d049",
   507 => x"1ec087d2",
   508 => x"49eaf8c2",
   509 => x"87f1c4fe",
   510 => x"497086c4",
   511 => x"87efc04a",
   512 => x"1ef2e6c2",
   513 => x"49eaf8c2",
   514 => x"87ddc4fe",
   515 => x"497086c4",
   516 => x"48d0ff4a",
   517 => x"c178c5c8",
   518 => x"976e7bd4",
   519 => x"486e7bbf",
   520 => x"7e7080c1",
   521 => x"ff058dc1",
   522 => x"d0ff87f0",
   523 => x"7278c448",
   524 => x"87c5059a",
   525 => x"e5c048c0",
   526 => x"c21ec187",
   527 => x"fe49eaf8",
   528 => x"c487c5c2",
   529 => x"059c7486",
   530 => x"ff87c4fe",
   531 => x"c5c848d0",
   532 => x"7bd3c178",
   533 => x"78c47bc0",
   534 => x"87c248c1",
   535 => x"262648c0",
   536 => x"264c264d",
   537 => x"0e4f264b",
   538 => x"0e5c5b5e",
   539 => x"66cc4b71",
   540 => x"87e7c002",
   541 => x"8cf0c04c",
   542 => x"87e6c002",
   543 => x"8ac14a74",
   544 => x"8a87df02",
   545 => x"8a87db02",
   546 => x"c087d702",
   547 => x"c0028ae0",
   548 => x"8ac187e2",
   549 => x"87e3c002",
   550 => x"7387e5c0",
   551 => x"87dafb49",
   552 => x"1e7487de",
   553 => x"d0f949c0",
   554 => x"731e7487",
   555 => x"87c9f949",
   556 => x"87cc86c8",
   557 => x"e5c14973",
   558 => x"7387c587",
   559 => x"87d1c249",
   560 => x"0087defe",
   561 => x"c6e6c21e",
   562 => x"b9c149bf",
   563 => x"59cae6c2",
   564 => x"c348d4ff",
   565 => x"d0ff78ff",
   566 => x"78e1c848",
   567 => x"c148d4ff",
   568 => x"7131c478",
   569 => x"48d0ff78",
   570 => x"2678e0c0",
   571 => x"4a711e4f",
   572 => x"c249a2c4",
   573 => x"6a48d9f7",
   574 => x"c1496978",
   575 => x"cae6c2b9",
   576 => x"87c0ff59",
   577 => x"87f8ccff",
   578 => x"4f2648c1",
   579 => x"c44a711e",
   580 => x"f7c249a2",
   581 => x"c27abfd9",
   582 => x"79bfc6e6",
   583 => x"711e4f26",
   584 => x"f8c21e4a",
   585 => x"fcfd49ea",
   586 => x"86c487e3",
   587 => x"dc029870",
   588 => x"f2e6c287",
   589 => x"eaf8c21e",
   590 => x"ecfffd49",
   591 => x"7086c487",
   592 => x"87c90298",
   593 => x"49f2e6c2",
   594 => x"c287e2fe",
   595 => x"2648c087",
   596 => x"4a711e4f",
   597 => x"eaf8c21e",
   598 => x"f0fbfd49",
   599 => x"7086c487",
   600 => x"87de0298",
   601 => x"49f2e6c2",
   602 => x"c287e1fe",
   603 => x"c21ef2e6",
   604 => x"fd49eaf8",
   605 => x"c487f5ff",
   606 => x"02987086",
   607 => x"48c187c4",
   608 => x"48c087c2",
   609 => x"00004f26",
   610 => x"00000000",
  others => ( x"00000000")
);

-- Xilinx Vivado attributes
attribute ram_style: string;
attribute ram_style of ram: signal is "block";

signal q_local : std_logic_vector((NB_COL * COL_WIDTH)-1 downto 0);

signal wea : std_logic_vector(NB_COL - 1 downto 0);

begin

	output:
	for i in 0 to NB_COL - 1 generate
		q((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH) <= q_local((i+1) * COL_WIDTH - 1 downto i * COL_WIDTH);
	end generate;
    
    -- Generate write enable signals
    -- The Block ram generator doesn't like it when the compare is done in the if statement it self.
    wea <= bytesel when we = '1' else (others => '0');

    process(clk)
    begin
        if rising_edge(clk) then
            q_local <= ram(to_integer(unsigned(addr)));
            for i in 0 to NB_COL - 1 loop
                if (wea(NB_COL-i-1) = '1') then
                    ram(to_integer(unsigned(addr)))((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH) <= d((i + 1) * COL_WIDTH - 1 downto i * COL_WIDTH);
                end if;
            end loop;
        end if;
    end process;

end arch;
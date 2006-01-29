# fetch rateup version number from input file and write them to STDOUT
BEGIN {
  while ((getline < ARGV[1]) > 0) {
    if (match ($0, /VERSION = "[^"]+"/)) {
      rateup_ver_str = substr($4, 2, length($4) - 3);
      split(rateup_ver_str, v, ".");
      gsub("[^0-9].*$", "", v[3]);
      rateup_ver = v[1] "," v[2] "," v[3];
    }
  }
  print "RATEUP_VERSION = " rateup_ver "";
  print "RATEUP_VERSION_STR = " rateup_ver_str "";
}

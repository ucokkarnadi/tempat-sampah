#!/usr/bin/perl
###########################
#
# Mohon caci makinya 
#
###########################

$|=1;
while (<>) {
my $chan = "";
open(my $fh, '>>', '/tmp/store-id.txt');
print $fh "IN= $_";

if (s/^(\d+\s+)//o) {
$chan = $1;
}
@X = split(" ",$_);

# YOUTUBE
if ($X[0] =~ m/^(https?)\:\/\/.*(youtube|google).*videoplayback.*/){
        @mode = $1;
	@itag = m/[&?](itag=[0-9]*)/;
        @id = m/[&?]id\=([^\&\s]*)/;
        @mime = m/[&?](mime\=[^\&\s]*)/;
        @cpn = m/[&?]cpn\=([^\&\s]*)/;
        @range = m/[&?](range=[^\&\s]*)/;
		if ($X[6] =~ m/\/(watch\?v\=|embed\/|v\/)([^\&\s]*)/) {
			@id = $2;
		}
        print $chan, "OK store-id=@mode://googlevideo.squid.internal/id=@id&@itag&@range&@mime\n" ;
	print $fh "OUT= $chan OK store-id=@mode://googlevideo.squid.internal/id=@id&@itag&@range&@mime\n";

# YTIMG
# https://i.ytimg.com/vi_webp/--hHEqmKrcY/default.webp
# https://i.ytimg.com/vi/pyUIQZnbCXM/default.jpg

} elsif ($X[0]=~ m/^(https?)\:\/\/i\.ytimg\.com\/vi(_webp|)\/([^\/]*)\/default\.(\w*)/) {
	print $chan, "OK store-id=$1://ytimg.squid.internal/$3.$4\n" ;
	print $fh "OUT= $chan OK store-id=$1://ytimg.squid.internal/$3.$4\n" ;

# FILEHIPPO
# http://fs32.filehippo.com/2755/fd1daeb334cc4735bd571acc6e47b246/ccsetup516.exe
# http://fs37.filehippo.com/2421/46cfd241f1da4ae9812f512f7b36643c/vlc-2.2.2-win64.exe

} elsif ($X[0]=~ m/^(https?):\/\/\w{4}\.filehippo\.com\/\d*\/\w*\/([^\s]*)/) {
	print $chan, "OK store-id=$1://filehippo.squid.internal/$2.jpg\n" ;
	print $fh "OUT= $chan OK store-id=$1://filehippo.squid.internal/$2.jpg\n" ;

# FB Photo
} elsif ($X[0]=~ m/^(https?)\:\/\/.*\.(fbcdn|akamaihd)\.net\/h(profile|photos|video)[^\/]*\/v\/[^\/]*\/([^\?]*).*/) {
	print $chan, "OK store-id=$1://fbcdn.net.squid.internal/$4\n" ;
	print $fh "OUT= $chan OK store-id=$1://fbcdn.net.squid.internal/$4\n" ;

# FB Static
} elsif ($X[0]=~ m/^(https?)\:\/\/.*(akamaihd|fbcdn).net.*rsrc\.php\/(.*(js|css|png|gif))(\?(.*)|$)/) {
	print $chan, "OK store-id=$1://fbcdn.net.squid.internal/static/$3\n" ;
	print $fh "OUT= $chan OK store-id=$1://fbcdn.net.squid.internal/static/$3\n" ;

# FB Ext Image
} elsif ($X[0]=~ m/^(https?)\:\/\/.*(akamaihd|fbcdn).net.*safe_image\.php\?.*url=([^\&\$]*).*$/) {
	print $chan, "OK store-id=$1://fbcdn.net.squid.internal/safe_image/$3\n" ;
	print $fh "OUT= $chan OK store-id=$1://fbcdn.net.squid.internal/safe_image/$3\n" ;

# ERROR
} else {
        print $chan, "ERR\n" ;
	print $fh "OUT= $chan ERR\n" ;
}

close $fh;
}

# A sample shell script to print domain ip address hosting information such as
# Location of server, city, weather, ip address owner, country and network range.  
# -------------------------------------------------------------------------------- 

# Die if no domains are given
[ -z $1 ] && { echo "Usage: $0 domain1.com domain2.com ..."; exit 1; }
let all=0
function get_dc_info {
	_ip=$(host $domain | grep 'has add' | head -1 | awk '{ print $4}')
	[ "$_ip" == "" ] && { echo "Error: $domain is not valid domain or dns error."; return 1; }
        echo "########## $domain [ $_ip ] ##########"	
        whois "$_ip" | egrep -w 'OrgName:|City:|Country:|OriginAS:|NetRange:'
	echo ""
	let all=$all+1
}

function get_weather_info {
	_city=$( whois "$_ip" | egrep -w 'City:' | awk '{print $2 $3}') 
        [ "$_city" == "" ] && { echo "Error: Didn't get valid city name."; return 1; } 
	curl https://wttr.in/$_city
        echo ""
}

for domain in $*; do
    get_dc_info $domain 
    get_weather_info
done;
    echo "TOTAL DOMAINS: $all"

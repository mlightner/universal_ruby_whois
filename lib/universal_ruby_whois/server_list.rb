# Define whois servers and their corresponding output format in this file.
# If no regular expressions are given to match states, some reasonable
# defaults will be used, but more specific is always better  :)

# More generic definitions should appear first, as the more specific definitions
# will overwrite them in the extension dictionary if they appear later in the file.

Whois::Server.define('ae', 'whois.uaenic.ae')
Whois::Server.define('ai', 'whois.ainic.ai')
Whois::Server.define('as', 'whois.nic.as')
Whois::Server.define('at', 'whois.nic.at')
Whois::Server.define('bg', 'whois.digsys.bg')
Whois::Server.define('bi', 'whois.nic.bi')
Whois::Server.define('bj', 'www.nic.bj')
Whois::Server.define('br', 'whois.nic.br')
Whois::Server.define('bz', 'whois.belizenic.bz')
Whois::Server.define('cc', 'whois.nic.cc')
Whois::Server.define('cd', 'whois.nic.cd')
Whois::Server.define('ck', 'whois.nic.ckcn')
Whois::Server.define('de', 'whois.denic.de')
Whois::Server.define('fo', 'whois.ripe.net')
Whois::Server.define('gg', 'whois.isles.net')
Whois::Server.define('gl', 'whois.ripe.net')
Whois::Server.define('gm', 'whois.ripe.net')
Whois::Server.define('gr', 'whois.grnet.gr')
Whois::Server.define('gs', 'whois.gs')
Whois::Server.define('hm', 'webhst1.capital.hm')
Whois::Server.define('hu', 'whois.nic.hu')
Whois::Server.define('id', 'whois.idnic.net.id')
Whois::Server.define('in', 'whois.inregistry.net')
Whois::Server.define('io', 'whois.nic.io')
Whois::Server.define('ir', 'whois.nic.ir')
Whois::Server.define('kz', 'whois.nic.kz')
Whois::Server.define('la', 'whois2.afilias-grs.net')
Whois::Server.define('ly', 'whois.lydomains.com')
Whois::Server.define('mc', 'whois.ripe.net')
Whois::Server.define('ms', 'whois.nic.ms')
Whois::Server.define('mx', 'whois.nic.mx')
Whois::Server.define('my', 'whois.mynic.net.my')
Whois::Server.define('pl', 'whois.dns.pl')
Whois::Server.define('pm', 'whois.nic.pm')
Whois::Server.define('pro', 'whois.registrypro.pro')
Whois::Server.define('pt', 'whois.nic.pt')
Whois::Server.define('sa', 'saudinic.net.sa')
Whois::Server.define('sb', 'whois.nic.net.sb')
Whois::Server.define('sh', 'whois.nic.sh')
Whois::Server.define('si', 'whois.arnes.si')
Whois::Server.define('sk', 'whois.sk-nic.sk')
Whois::Server.define('sm', 'whois.ripe.net')
Whois::Server.define('st', 'whois.nic.st')
Whois::Server.define('su', 'whois.ripn.net')
Whois::Server.define('tc', 'whois.tc')
Whois::Server.define('th', 'whois.thnic.net')
Whois::Server.define('to', 'whois.tonic.to')
Whois::Server.define('tv', 'tvwhois.verisign-grs.com')
Whois::Server.define('uy', 'www.nic.org.uy')
Whois::Server.define('uz', 'whois.cctld.uz')
Whois::Server.define('va', 'whois.ripe.net')
Whois::Server.define('ve', 'whois.nic.ve')
Whois::Server.define('vg', 'whois.vg')
Whois::Server.define('wf', 'whois.nic.wf')
Whois::Server.define('ws', 'whois.tld.ws')
Whois::Server.define('yt', 'whois.nic.yt')
Whois::Server.define('us', 'whois.nic.us')
Whois::Server.define('at', 'whois.nic.at')
Whois::Server.define('ca', 'whois.cira.ca')
Whois::Server.define('cc', 'whois.nic.cc')
Whois::Server.define('ch', 'whois.nic.ch')
Whois::Server.define('cn', 'whois.cnnic.net.cn')
Whois::Server.define('cz', 'whois.nic.cz')
Whois::Server.define('ee', 'whois.eenet.ee')
Whois::Server.define('gr', 'https://grweb.ics.forth.gr/')
Whois::Server.define('it', 'whois.nic.it')
Whois::Server.define('li', 'whois.nic.li')
Whois::Server.define('lt', 'whois.domreg.lt')
Whois::Server.define('lu', 'whois.dns.lu')
Whois::Server.define('lv', 'whois.ripe.net')
Whois::Server.define('ms', 'whois.adamsnames.tc')
Whois::Server.define('co.nz', 'whois.domainz.net.nz')
Whois::Server.define('nu', 'whois.nic.nu')
Whois::Server.define('pl', 'whois.dns.pl')
Whois::Server.define('ro', 'whois.rotld.ro')
Whois::Server.define('ru', 'whois.ripn.net')
Whois::Server.define('se', 'whois.iis.se')
Whois::Server.define('sk', 'whois.ripe.net')
Whois::Server.define('tc', 'whois.adamsnames.tc')
Whois::Server.define('vg', 'whois.adamsnames.tc')
Whois::Server.define('ws', 'whois.worldsite.ws')
Whois::Server.define('gd', 'whois.adamsnames.tc')

#Whois::Server.define('es',"https://www.nic.es/esnic/servlet/BuscarDomSolAlta?dominio=%DOMAIN%")
#Whois::Server.define('com.es',"https://www.nic.es/esnic/servlet/BuscarDomSolAlta?dominio=%DOMAIN%")

Whois::Server.define(
  %w(jp co.jp or.jp ne.jp ac.jp ad.jp ed.jp go.jp gr.jp lg.jp),
  ['http://whois.jprs.jp/en/', :post, { :submit => 'query', :key => '%DOMAIN%', :type => 'DOM'}],
  :registered => /Domain Information\:/im,
  :free => /No match\!\!/im
)

Whois::Server.define(
  %w(es com.es nom.es org.es gob.es edu.es),
  ['https://www.nic.es/esnic/servlet/BuscarDomSolAlta', :post, { :Submit => 'Buscar', :domino => '%DOMAIN_NO_TLD%',
    :sufijo => '%TLD%', :tipo => 'dominio'}],
  :registered => [%q{%DOMAIN% </a> </th> <td class="disp"> <img src="../images/icon_disp_no.gif" alt="no" />}, 'im'],
  :free => [%q{%DOMAIN% </a> </th> <td class="disp"> <img src="../images/icon_disp_yes.gif" alt="si" />}, 'im']
)

# By leaving out the whois server, we force it to follow the internic redirection.
Whois::Server.define(
  [ 'com', 'net', 'edu' ], nil,
  :registered => /No match for/im.invert!,
  :free => /No match for/im
)

Whois::Server.define(
  'gov', 'whois.nic.gov',
  :registered => /Status:\s*Active/im,
  :free => /Status:\s*Active/im.invert!
)

Whois::Server.define(
  %w(asn.au com.au id.au net.au org.au), 
  'whois.ausregistry.net.au',
  :free => /No Data Found/im,
  :registered => /Last Modified/im,
  :error => /BLACKLISTED/m
)

Whois::Server.define(
 %w(hk com.hk net.hk edu.hk org.hk gov.hk idv.hk),
 'whois.hkdnr.net.hk',
  :free => /Domain Not Found/,
  :registered => /Domain Name\:/im
)
Whois::Server.define(
  %w(co.nz net.nz org.nz geek.nz school.nz gen.nz govt.nz maori.nz ac.nz iwi.nz cri.nz mil.nz parliament.nz),
  'whois.srs.net.nz',
  :free => /220 available/im,
  :registered => /220 available/im.invert!
)
Whois::Server.define(
  %w(eu.com uk.com uk.net us.com la cn.com de.com jpn.com kr.com no.com za.com br.com ar.com ru.com sa.com se.com
     se.net hu.com gb.com gb.net qc.com uy.com ae.org no.com se.com),
  'whois.centralnic.net',
  :free => /available for registration/im,
  :registered => /Domain Name\:/im
  )
Whois::Server.define(
  'be',
  'whois.dns.be',
  :free => /Status:\s+FREE/im,
  :registered => /Status:\s+REGISTERED/im
)
Whois::Server.define(
  'biz',
  'whois.neulevel.biz',
  :free => /Not found:/im,
  :registered => /Domain Name:/im
)
Whois::Server.define(
  %w(co.uk org.uk me.uk ltd.uk plc.uk net.uk sch.uk),
  'whois.nic.uk',
  :registered => /Domain name:/im,
  :free => /No match for/im,
  :error => /Error for/im
)
Whois::Server.define(
  'de',
  'whois.denic.de',
  :error => /Status:\s+invalid/im,
  :registered => /Status:\s+connect/im,
  :free => /Status:\s+free/im
)
Whois::Server.define(
  'dk',
  'whois.dk-hostmaster.dk',
  :registered => /Registered:/im,
  :error => /Your request is not valid./im,
  :free => /No entries found for the selected source./im
)
Whois::Server.define(
  'eu',
  'whois.eu',
  :free => /Nameservers\:/im.invert!,
  :registered => /Nameservers\:/im,
  :pending => /APPLICATION PENDING/im,
  :error => /NOT ALLOWED/im
)
Whois::Server.define(
  'info',
  'whois.afilias.info',
  :error => /Not a valid domain search pattern/im,
  :registered => /Domain Name:/im,
  :free => /NOT FOUND/im
)
Whois::Server.define(
  'name',
  'whois.nic.name',
  :registered => /Not available for second level registration./im,
  :preserved => /Not available for second level registration./im,
  :free => /No match./im
)

# Whois::Server.define(
#   'net',
#   'whois.verisign-grs.com',
#   :registered => /Domain Name:/im,
#   :free => /No match for/im
# )
Whois::Server.define(
  'nl',
  'whois.domain-registry.nl',
  :registered => /active/im,
  :free => /free/im,
  :error => /invalid domain/im,
  :preserved => /excluded/im
)
Whois::Server.define(
  'org',
  'whois.publicinterestregistry.net',
  :registered => /Domain Name:/im,
  :free => /NOT FOUND/im,
  :error => /Not a valid domain search pattern/im  
)
Whois::Server.define(
  'cc',
  'whois.nic.cc',
  :registered => /Domain Name:/im,
  :free => /No match for/im
  
)
Whois::Server.define(
  'ru',
  'whois.ripn.net',
  :registered => /domain:/im,
  :free => /No entries found/im
  
)
Whois::Server.define(
  'cat',
  'whois.cat',
  :registered => /Domain Name: /im,
  :free => /NOT FOUND/im
  
)
Whois::Server.define(
  %w(travel jobs aero pw tw),
  'whois.encirca.com',
  :registered => /Domain Registrar Status:/im,
  :free => /Not found:/im
)
Whois::Server.define(
  'mobi',
#  'whois.corenic.net',
  'whois.dotmobiregistry.net',
  :registered => /is not registered/im.invert!,
  :free => /is not registered/im
)
Whois::Server.define(
  'ca',
  'whois.cira.ca',
  :registered => /EXIST/im,
  :free => /AVAIL/im
)
Whois::Server.define(
  'asia', 
  'whois.nic.asia',
  :registered => /Domain ID/im,
  :free => /NOT FOUND/im
)
Whois::Server.define(
  'co.il',
  'whois.isoc.org.il',
  :registered => /validity:/im,
  :free => /No data was found to match the request criteria./im
)
Whois::Server.define(
  'ac.uk',
  'whois.ja.net',
  :registered => /Domain:/im,
  :free => /No such domain/im
)
Whois::Server.define(
  %w(cx cm ht ki mu nf sb tl),
  'whois.nic.cx',
  :registered => //im,
  :free => /(Not Registered|No Applications Pending)/im
)
Whois::Server.define(
  %w(gd tc vg ms),
  'whois.adamsnames.tc',
  :free => /is not registered/im,
  :registered => /is registered/im
)
Whois::Server.define(
  'nu', 
  'whois.nic.nu',
  :free => /NO MATCH.*/,
  :registered => /Domain Name/
)

Whois::Server.define(
  'no',
  'whois.norid.no',
  :registered => /Domain Information/im,
  :free => /% no matches/im,
  :creation_date => /(Created:)\s*([\w\-]+)[^\n\r]*[\n\r]/im
)


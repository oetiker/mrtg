#
# <ul>
#   <li>
#       <div><a href="../../index.de.html">Willkommen</a></div>
#   </li>
#   <li>
#       <div><a href="../../events/index.de.html">Veranstaltungen</a></div>
#   </li>
#   <li>
#       <div><a href="../../collegium/history.de.html">Das Collegium</a></div>
#   </li>
#   <li>
#       <div class="selected_head"><a href="../../who/employee/index.de.html">Who is who</a></div>
#       <ul>
#         <li>
#             <div><a href="../../who/employee/index.de.html">Mitarbeiter</a></div>
#         </li>
#         <li>
#             <div class="selected">Fellows</div>
#             <ul>
#                <li>
#                    <div><a href="../../who/fellows/dalferth.de.html">Dalferth</a></div>
#                </li>
#                <li>
#                    <div><a href="../../who/fellows/fehr.de.html">Fehr</a></div>
#                </li>
#             </ul>
#          </li>
#       </ul>
#   </li>
# </ul>
<define-tag nav:bar endtag=required>
   <set-var __nav:level=%0 />
   <navbar:define name="%1" urlbase="$(ROOT)/%2">
   <navbar:header>
      <ul*>
   </navbar:header>
   <navbar:footer>
      </ul*>
   </navbar:footer>
   <navbar:prolog>
     <li*><div*></navbar:prolog>
   <navbar:epilog></div*></li*>
   </navbar:epilog>
   <navbar:prolog type="S"><li*><div* class="selected"></navbar:prolog>
   <navbar:epilog type="S"></div></li*>
   </navbar:epilog>
   <navbar:filter>
	   <protect pass=2>
           my ($mcode, $CFG, $select) = @_;
	   # have the top selected too
           $mcode =~ s|<div>(.+?)</a><ul>|<div class="selected_head">$1</a></div><ul>|g;
           $mcode =~ s|<div class="selected">([^<]+?)<ul>|<div class="selected">$1</div><ul>|g;
           $mcode =~ s|</a><ul>|</a></div><ul>|g;
           $mcode =~ s|</ul>\s*</div>\s*</li>|</ul></li>|g;
           return $mcode;
	   </protect>
   </navbar:filter>
   %body
   </navbar:define>
</define-tag>

<define-tag nav:but>
   <if <match "%2" "http://|html$|\?" />
   <navbar:button id="%0" 
                    url="%2" 
                    txt="%1"
   		    menu="%3"
     />
     <navbar:button id="%0" 
	            url="%2.<lang:star: * />.html"
		    txt="%1 "
		    menu="%3"
     />
     />
</define-tag>

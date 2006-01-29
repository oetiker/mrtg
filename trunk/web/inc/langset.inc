#
#
# all definitions in the include rely on the existence of $LANG 
#
#
###############################################################################
# define base languages of the document
###############################################################################
#use wml::std::lang
<set-var lntmp=<downcase "$(LANGS)" /> />
<while <match <get-var lntmp /> "[a-z][a-z]" />>
  <set-var lan=<match <get-var lntmp /> "[a-z][a-z]" action=extract /> />
  <set-var lntmp=<match <get-var lntmp /> "[a-z][a-z]" action=delete /> />
  <lang:new id=<get-var lan /> short />
</while>

###############################################################################
## creates .var file for automatic language selection 
###############################################################################
[LANG_VAR:
URI: $(WML_SRC_BASENAME)
<set-var lntmp=<downcase "$(LANGS)" /> />
<while <match <get-var lntmp /> "[a-z][a-z]" /> >
  <set-var lan=<match <get-var lntmp /> "[a-z][a-z]" action=extract /> />
  <set-var lntmp=<match <get-var lntmp /> "[a-z][a-z]" action=delete /> />
<protect></protect>
URI: $(WML_SRC_BASENAME).<get-var lan />.html
Content-type: text/html
Content-language: <get-var lan />
</while>
<protect></protect>
URI: $(WML_SRC_BASENAME).en.html
Content-type: text/html
:LANG_VAR]

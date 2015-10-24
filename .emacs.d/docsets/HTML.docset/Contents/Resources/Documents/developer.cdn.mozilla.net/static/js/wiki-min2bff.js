(function(t){"use strict";var e=function(){var e="mdn.search";var a=["key","data"];var n=function(t){return e+"."+t};return{flush:function(){var e=this;t.each(a,function(t,a){e.removeItem(a)})},serialize:function(t){return JSON.stringify(t)},deserialize:function(t){if(typeof t!=="string"){return undefined}try{return JSON.parse(t)}catch(e){return t||undefined}},getItem:function(t){return this.deserialize(sessionStorage.getItem(n(t)))},setItem:function(t,e){return sessionStorage.setItem(n(t),this.serialize(e))},removeItem:function(t){return sessionStorage.removeItem(n(t))}}}();if(t("body").hasClass("search-navigator-flush")){e.flush()}t.fn.mozSearchResults=function(a){var n=e.getItem("key");var i=t(".from-search-next");var r=t(".from-search-previous");var s;var o;var c;if(!n&&!a){return}var l=function(e){if(!e||!e.documents||!e.documents.length){return}var a=t("body").data("slug");var n=document.createDocumentFragment();var c;var l;if(e.query){t("#main-q").attr("data-value",e.query)}t.each(e.documents,function(){if(this.slug===a){c=this.slug}});if(!c)return;t(".from-search-navigate-wrap").removeClass("hidden");l=t(".from-search-toc ol");l.on("click","a",function(){mdn.analytics.trackEvent({category:"Search doc navigator",action:"Click",label:t(this).attr("href"),value:c})});t.each(e.documents,function(c,l){var d=t("<a>",{text:l.title,href:l.url});if(l.slug===a){d.addClass("current");s=e.documents[c+1];if(s){i.attr("href",s.url).on("click",function(){mdn.analytics.trackEvent({category:"Search doc navigator",action:"Click next",label:s.url,value:s.id})}).removeClass("disabled")}else{i.attr("title",i.attr("data-empty-title"))}o=e.documents[c-1];if(o){r.attr("href",o.url).on("click",function(){mdn.analytics.trackEvent({category:"Search doc navigator",action:"Click previous",label:o.url,value:o.id})}).removeClass("disabled")}else{r.attr("title",i.attr("data-empty-title"))}}n.appendChild(t("<li></li>").append(d).get(0))});l.append(n);t("#wiki-document-head").addClass("from-search")};if(!a){if(n){a=n}}else{e.setItem("key",a)}c=e.getItem("data");if(!c){t.ajax({url:a,dataType:"json",success:function(t){e.setItem("data",t);l(t)},error:function(t,e,n){console.error(a,e,n.toString())}})}else{l(c)}return this}})(jQuery);(function(t,e,a){"use strict";a(".toggleable").mozTogglers();(function(){var t=a("#quick-links");r(t.find("> ul > li, > ol > li"));t.find(".toggleable").mozTogglers();var e=a("#wiki-column-container");var n=a("#wiki-controls .quick-links");var i=a("#wiki-left").get(0);if(i){var s=i.parentNode}a("#quick-links-toggle, #show-quick-links").on("click",function(t){t.preventDefault();a(i).toggleClass("column-closed");e.toggleClass("wiki-left-closed");n.toggleClass("hidden");if(a(i).hasClass("column-closed")){s.removeChild(i)}else{s.appendChild(i)}mdn.analytics.trackEvent({category:"Wiki",action:"Sidebar",label:this.id==="quick-links-toggle"?"Hide":"Show"})})})();a(".subnav").each(function(){var t=a(this);var n=t.find(" > ol");var i=a(".zone-landing-header-preview-base").length?l:c;if(!n.length)return;r(n.find("li"));n.find(".toggleable").mozTogglers({slideCallback:i});var s=[];var o=n.find('a[href$="'+e.location.pathname+'"]');o.each(function(){var t=this;var e=a(this).parents(".toggleable").find(".toggler");e.each(function(){if(a.contains(a(this).parent("li").get(0),t)&&s.indexOf(this)===-1){a(this).trigger("mdn:click");s.push(this)}})}).parent().addClass("current");n.addClass("accordion");function c(){}function l(){if(a(".zone-landing-header-preview-base").css("position")==="absolute"){a(".wiki-main-content").css("min-height",t.height())}}i()});(function(){var t=a(e.body).data("search-url");if(t){a(".from-search-toc").mozSearchResults(t)}})();var n=a(".from-search-navigate");if(n.length){var i=a(".from-search-toc");n.mozMenu({submenu:i,brickOnClick:true,onOpen:function(){mdn.analytics.trackEvent({category:"Search doc navigator",action:"Open on hover"})},onClose:function(){mdn.analytics.trackEvent({category:"Search doc navigator",action:"Close on blur"})}});i.find("ol").mozKeyboardNav()}a(".page-watch a").on("click",function(t){t.preventDefault();var e=a(this);if(e.hasClass("disabled"))return;var n=e.closest("form");var i=mdn.Notifier.growl(e.data("subscribe-status"),{duration:0});e.addClass("disabled");a.ajax(n.attr("action"),{cache:false,method:"post",data:n.serialize()}).done(function(t){var a;t=JSON.parse(t);if(Number(t.status)===1){e.text(e.data("unsubscribe-text"));a=e.data("subscribe-message")}else{e.text(e.data("subscribe-text"));a=e.data("unsubscribe-message")}i.success(a,2e3);e.removeClass("disabled")})});function r(t){t.each(function(){var t=a(this);var e=t.find("> ul, > ol");if(e.length){t.addClass("toggleable closed");t.find("> a").addClass("toggler").prepend('<i aria-hidden="true" class="icon-caret-up"></i>');e.addClass("toggle-container")}})}a(".external").each(function(){var t=a(this);if(!t.find("img").length)t.addClass("external-icon")});if(a("article pre").length&&"querySelectorAll"in e)(function(){var t=e.createElement("script");t.setAttribute("data-manual","");t.async="true";t.src=mdn.staticPath+"js/syntax-prism-min.js?build="+mdn.build;e.body.appendChild(t)})();(function(){var t={css:{link:"/docs/Web/CSS/Value_definition_syntax",title:gettext("How to read CSS syntax."),urlTest:"/docs/Web/CSS/",classTest:"brush:css"},html:{urlTest:"/docs/Web/HTML/",classTest:"brush:html"},js:{urlTest:"/docs/Web/JavaScript/",classTest:"brush:js"},api:{urlTest:"/docs/Web/API/",classTest:"brush:js"}};var e=a(".syntaxbox, .twopartsyntaxbox");if(e.length){var n=false;var i;for(var r in t){var s=t[r].link;var o=t[r].urlTest;if(window.location.href.indexOf(s)>-1){n=true}if(window.location.href.indexOf(o)>-1){i=t[r]}}if(!n){e.each(function(){var e=a(this);var n;if(e.hasClass("twopartsyntaxbox")){n=t.css}for(var r in t){var s=t[r].classTest;if(e.hasClass(s)){n=t[r]}}if(!n&&i){n=i}if(n){if(n.link&&n.title){var o=n.link;var c=n.title;var l=a('<a href="'+o+'" class="syntaxbox-help icon-only" lang="en"><i aria-hidden="true" class="icon-question-sign"></i><span>'+c+"</span></a>");e.before(l);e.on("mouseenter",function(){l.addClass("isOpaque")});e.on("mouseleave",function(){l.removeClass("isOpaque")})}}})}}})();(function(){var n=a(".bc-api table tbody tr");if(!n.length)return;if(!t.waffle||!t.waffle.flag_is_active("compat_api"))return;a("<link />").attr({href:mdn.staticPath+"css/wiki-compat-tables-min.css",type:"text/css",rel:"stylesheet"}).on("load",function(){a.ajax({url:mdn.staticPath+"js/wiki-compat-tables-min.js",dataType:"script",cache:true}).then(function(){n.mozCompatTable()})}).appendTo(e.head)})();a("#toc").on("click","a",function(){var t=a(this);mdn.analytics.trackEvent({category:"TOC Links",action:t.text(),label:t.attr("href")})});a(".crumbs").on("click","a",function(){var t=this.href;mdn.analytics.trackEvent({category:"Wiki",action:"Crumbs",label:t},function(){window.location=t})});(function(){var n=a("#toc");var i=n.offset();var r=n.find("> .toggler");var o="fixed";var c=a("#wiki-right");var l=a(".page-buttons");var d=l.offset();var u=l.attr("data-sticky")==="true";var f=a("html").attr("dir")==="rtl"?"left":"right";var h=s(function(s){var c=a(e).scrollTop();var h=0;var m=a(".wiki-main-content");var v=r.css("pointer-events");if(!s||s.type==="resize"){if(f==="right"){d.right=a(t).width()-m.offset().left-m.innerWidth()}if(n.length){if(v==="auto"||r.find("i").css("display")!=="none"){if(!n.attr("data-closed")&&!r.attr("data-clicked")){r.trigger("mdn:click")}}else if(n.attr("data-closed")){r.trigger("mdn:click")}}}if(u){h=l.innerHeight();if(c>d.top){l.addClass(o);if(l.css("position")==="fixed"){l.css("min-width",l.css("width"));l.css(f,d[f])}}else{l.removeClass(o)}}if(!n.length)return;var p=t.innerHeight-parseInt(n.css("padding-top"),10)-parseInt(n.css("padding-bottom"),10)-h;if(c+h>i.top&&v==="none"){n.css({width:n.css("width"),top:h,maxHeight:p});n.addClass(o)}else{n.css({width:"auto",maxHeight:"none"});n.removeClass(o)}},15);if(n.length||u){h();a(t).on("scroll resize",h)}})();a(".htab").each(function(t){var e=a(this);var n=e.find(">ul>li");e.append(a("div[id=compat-desktop]")[t]);e.append(a("div[id=compat-mobile]")[t]);n.find("a").on("click mdn:click",function(t){var i=a(this);if(t){t.preventDefault();t.stopPropagation()}n.removeClass("selected");i.parent().addClass("selected");e.find(">div").hide().eq(n.index(i.parent())).show()}).eq(0).trigger("mdn:click")});a(".wiki-l10n").on("change",function(){if(this.value){t.location=this.value}});a("body[contextmenu=edit-history-menu]").mozContextMenu(function(t,e){var n=e.find("menuitem");var i=a("body");var r=!document.getSelection().isCollapsed;var s=a(t).is("a")||a(t).parents().is("a");var o=a(t).is("img");if(s||r||o){i.attr("contextmenu","")}e.on("click",function(t){location.href=a(t.target).data("action")+"?src=context"})});a(".kserrors-details-toggle").toggleMessage({toggleCallback:function(){a(".kserrors-details").toggleClass("hidden")}});a(".stack-form").html('<form action="http://stackoverflow.com/search"><i class="stack-icon" aria-hidden="true"></i><label for="stack-search" class="offscreen">'+gettext("Search Stack Overflow")+'</label><input id="stack-search" placeholder="'+gettext("Search Stack Overflow")+'" /><button type="submit" class="offscreen">Submit Search</button></form>').find("form").on("submit",function(e){e.preventDefault();var n=a(this).find("#stack-search").val();if(n!==""){t.location="http://stackoverflow.com/search?q=[firefox]+or+[firefox-os]+or+[html5-apps]+"+n}});(function(){var e="hidden";var n=a(".contributor-avatars");var i;var r;function s(t){return n.find(t).mozLazyloadImage()}if(n.css("display")==="none")return;s("li.shown noscript");if(n.data("has-hidden")){r=a('<button type="button" class="transparent">'+n.data("all-text")+"</button>");r.on("click",function(t){t.preventDefault();mdn.analytics.trackEvent({category:"Top Contributors",action:"Show all"});i=n.find("li."+e);i.removeClass(e);s("noscript");a(i.get(0)).find("a").get(0).focus();a(this).remove()});r.appendTo(n)}n.on("click","a",function(e){var n=e.metaKey||e.ctrlKey;var i=this.href;var r=a(this).parent().index()+1;var s={category:"Top Contributors",action:"Click position",label:r};if(n){mdn.analytics.trackEvent(s)}else{e.preventDefault();mdn.analytics.trackEvent(s,function(){t.location=i})}});n.find("ul").on("focusin focusout",function(t){a(this)[(t.type==="focusin"?"add":"remove")+"Class"]("focused")})})();if(a("math").length)(function(){var t=a('<div class="offscreen"><math xmlns="http://www.w3.org/1998/Math/MathML"><mspace height="23px" width="77px"/></math></div>').appendTo(document.body);var n=t.get(0).firstChild.firstChild.getBoundingClientRect();t.remove();var i=Math.abs(n.height-23)<=1&&Math.abs(n.width-77)<=1;if(!i){a('<link href="'+mdn.staticPath+'css/libs/mathml.css" rel="stylesheet" type="text/css" />').appendTo(e.head);a("#wikiArticle").prepend('<div class="notice"><p>'+gettext("Your browser does not support MathML. A CSS fallback has been used instead.")+"</p></div>")}})();(function(){var e=a(".revision-list-controls .link-btn");if(e.length){var n=e.offset().top;a(t).on("scroll",function(){var t=e;var i=a(this).scrollTop();t.toggleClass("fixed",i>=n)})}})();function s(t,e,a){var n;return function(){var i=this,r=arguments;var s=function(){n=null;if(!a)t.apply(i,r)};var o=a&&!n;clearTimeout(n);n=setTimeout(s,e);if(o)t.apply(i,r)}}(function(){var n=a('iframe[src*="youtube.com/embed"]');var i=[];var r=1;var s;function o(){var t;r=1;a.each(i,function(e,a){if(a.getPlayerState()!==1)return;r=0;t=a.getCurrentTime()/a.getDuration();if(!a.checkpoint){a.checkpoint=.1+Math.round(t*10)/10}if(t>a.checkpoint){mdn.analytics.trackEvent({category:"YouTube",action:"Percent Completed",label:a.getVideoUrl(),value:Math.round(a.checkpoint*100)});a.checkpoint+=.1}});if(r){if(s)clearTimeout(s)}else{s=setTimeout(o,6e3)}}if(!n.length)return;var c=t.location.protocol+"//"+t.location.hostname+(t.location.port?":"+t.location.port:"");n.each(function(){a(this).attr("src",function(t,e){return e+(e.split("?")[1]?"&":"?")+"&enablejsapi=1&origin="+c})});var l=e.createElement("script");l.async="true";l.src="//www.youtube.com/iframe_api";e.body.appendChild(l);t.onYouTubeIframeAPIReady=function(e){n.each(function(e){i[e]=new YT.Player(a(this).get(0));i[e].addEventListener("onStateChange",function(t){var a;switch(t.data){case 0:a="Finished";break;case 1:a="Play";if(r){o()}break;case 2:a="Pause";break;case 3:a="Buffering";break;default:return}mdn.analytics.trackEvent({category:"YouTube",action:a,label:i[e].getVideoUrl()})});i[e].addEventListener("onPlaybackQualityChange",function(t){var a;switch(t.data){case"small":a=240;break;case"medium":a=360;break;case"large":a=480;break;case"hd720":a=720;break;case"hd1080":a=1080;break;case"highres":a=1440;break;default:a=0}mdn.analytics.trackEvent({category:"YouTube",action:"Playback Quality",label:i[e].getVideoUrl(),value:a})});i[e].addEventListener("onError",function(e){mdn.analytics.trackError("YouTube Error: "+e.data,t.location.href)})})}})();function o(){var t=function(t){var e=t.createElement("details");var a;var n;var i;if(!("open"in e)){return false}n=t.body||function(){var e=t.documentElement;a=true;return e.insertBefore(t.createElement("body"),e.firstElementChild||e.firstChild)}();e.innerHTML="<summary>a</summary>b";e.style.display="block";n.appendChild(e);i=e.offsetHeight;e.open=true;i=i!=e.offsetHeight;n.removeChild(e);if(a){n.parentNode.removeChild(n)}return i}(document);if(t)return;a("details").addClass("no-details").each(function(){var t=a(this);var n=a("summary",t);var i=t.children(":not(summary)");var r=t.contents(":not(summary)");if(!n.length){n=a(e.createElement("summary")).text(gettext("Details")).prependTo(t)}if(i.length!==r.length){r.filter(function(){return this.nodeType===3&&/[^\t\n\r ]/.test(this.data)}).wrap("<span>");i=t.children(":not(summary)")}if(typeof t.attr("open")!=="undefined"){t.addClass("open");i.show()}else{i.hide()}n.attr("tabindex",0).attr("role","button").on("click",function(){n.focus();if(typeof t.attr("open")!=="undefined"){t.removeAttr("open");n.attr("aria-expanded","false")}else{t.attr("open","open");n.attr("aria-expanded","true")}i.slideToggle();t.toggleClass("open")}).on("keyup",function(t){if(32==t.keyCode||13==t.keyCode){t.preventDefault();n.click()}})})}if(a("details").length){o()}})(window,document,jQuery);(function(t,e,a){"use strict";if(!t.waffle||!t.waffle.flag_is_active("wiki_samples"))return;var n=["codepen","jsfiddle"];var i="frame_".length;var r=a("link[rel=canonical]").attr("href")||t.location.href.split("#")[0];var s="<!-- Learn about this code on MDN: "+r+" -->\n\n";var o='<input type="hidden" name="utm_source" value="mdn" />'+'<input type="hidden" name="utm_medium" value="code-sample" />'+'<input type="hidden" name="utm_campaign" value="external-samples" />';a(".sample-code-frame").each(function(){var t=a(this);var e=t.parents(".sample-code-table").get(0);var n=t.attr("id").substring(i);var r=t.attr("src").replace(/^https?:\/\//,"");r=r.slice(r.indexOf("/"),r.indexOf("$"));a(e||t).after(function(){return u(n,r)})});a("#wikiArticle").on("click","button.open-in-host",function(){var t=a(this);var e=t.attr("data-section");var n=t.attr("data-source");var i=t.attr("data-host");mdn.analytics.trackEvent({category:"Samples",action:"open-"+i,label:e});t.attr("disabled","disabled");a.get(n+"?section="+e+"&raw=1").then(function(n){var r=a("<div />").append(n);var s=r.find("pre[class*=html]").text();var o=r.find("pre[class*=css]").text();var c=r.find("pre[class*=js]").text();var l=r.find("h2[name="+e+"]").text();d(i,l,s,o,c);t.removeAttr("disabled")})});function c(t,n,i,r){var c=a('<form method="post" action="https://jsfiddle.net/api/mdn/" class="hidden">'+'<input type="hidden" name="html" />'+'<input type="hidden" name="css" />'+'<input type="hidden" name="js" />'+'<input type="hidden" name="title" />'+'<input type="hidden" name="wrap" value="b" />'+o+'<input type="submit" />'+"</form>").appendTo(e.body);c.find("input[name=html]").val(s+n);c.find("input[name=css]").val(i);c.find("input[name=js]").val(r);c.find("input[name=title]").val(t);c.get(0).submit()}function l(t,n,i,r){var c=a('<form method="post" action="https://codepen.io/pen/define" class="hidden">'+'<input type="hidden" name="data">'+o+'<input type="submit" />'+"</form>").appendTo(e.body);var l={title:t,html:s+n,css:i,js:r};c.find("input[name=data]").val(JSON.stringify(l));c.get(0).submit()}function d(t,e,a,n,i){if(t==="jsfiddle"){c(e,a,n,i)}else if(t==="codepen"){l(e,a,n,i)}}function u(t,e){var i=a('<div class="open-in-host-container" />');a.each(n,function(){var a=this.toLowerCase();i.append(['<button class="open-in-host" ','data-host="',a,'" ','data-section="',t,'"','data-source="',e,'">','<i aria-hidden="true" class="icon-',a,'"></i> ',"Open in ",this,"</button>"].join(""))});return i}})(window,document,jQuery);
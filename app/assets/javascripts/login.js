function about() {
	info = document.getElementById('about-content');
	if (window.XMLHttpRequest) {
		xhr = new XMLHttpRequest();	
	}
	else
	{ xhr = new ActiveXObject("Microsoft.XMLHTTP"); }
	xhr.open("GET","rails/info/properties",false);
	xhr.send("");
	info.innerHTML = xhr.responseText;
	info.style.display = 'block'
}
(function() {
	var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
	po.src = 'https://apis.google.com/js/client:plusone.js';
	var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
})();
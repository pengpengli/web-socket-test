<!DOCTYPE html>
<html>
<head>
    <title>WebSocket/SockJS Echo Sample (Adapted from Tomcat's echo sample)</title>
    <style type="text/css">
        #connect-container {
            float: left;
            width: 400px
        }

        #connect-container div {
            padding: 5px;
        }

        #console-container {
            float: left;
            margin-left: 15px;
            width: 400px;
        }

        #console {
            border: 1px solid #CCCCCC;
            border-right-color: #999999;
            border-bottom-color: #999999;
            height: 300px;
            overflow-y: scroll;
            padding: 5px;
            width: 100%;
        }

        #console p {
            padding: 0;
            margin: 0;
        }
    </style>

    <script src="http://cdn.jsdelivr.net/sockjs/1.0.1/sockjs.min.js"></script>

    <script type="text/javascript">
        var ws = null;
        var url = null;
        var transports = [];
        var p = null;
        var console = null;

        function setConnected(connected) {
            document.getElementById('connect').disabled = connected;
            document.getElementById('disconnect').disabled = !connected;
            document.getElementById('echo').disabled = !connected;
        }

        function connect() {
            alert("url:" + url);
            if (!url) {
                alert('Select whether to use W3C WebSocket or SockJS');
                return;
            }

            ws = (url.indexOf('sockjs') != -1) ?
                    new SockJS(url, undefined, {protocols_whitelist: transports}) : new WebSocket(url);

            ws.onopen = function () {
                setConnected(true);
                log('Info: connection opened.\n');
            };
            ws.onmessage = function (event) {
                log('Received: ' + event.data);
            };
            ws.onclose = function (event) {
                setConnected(false);
                log('Info: connection closed./n');
                log(event);
            };
        }

        function disconnect() {
            if (ws != null) {
                ws.close();
                ws = null;
            }
            setConnected(false);
        }

        function echo() {
            if (ws != null) {
                var message = document.getElementById('message').value;
                log('Sent: ' + message + '\n');
                ws.send(message);
            } else {
                alert('connection not established, please connect.');
            }
        }

        function updateUrl(urlPath) {
            if (urlPath.indexOf('sockjs') != -1) {
                url = urlPath;
                document.getElementById('sockJsTransportSelect').style.visibility = 'visible';
            }
            else {
                if (window.location.protocol == 'http:') {
                    url = 'ws://' + window.location.host + urlPath;
                } else {
                    url = 'wss://' + window.location.host + urlPath;
                }
                document.getElementById('sockJsTransportSelect').style.visibility = 'hidden';
            }
        }

        function updateTransport(transport) {
            alert(transport);
            transports = (transport == 'all') ? [] : [transport];
        }

        String.prototype.endWith = function (startStr) {
            var len = startStr.length;
            return (len >= 0 && this.lastIndexOf(startStr) == (this.length - len));
        };

        function log(message) {
            if (console == null) {
                console = document.getElementById('console');
            }

            if (p == null) {
                p = document.createElement('p');
                console.appendChild(p);
                p.appendChild(document.createTextNode(''));
                p.style.wordWrap = 'break-word';
            }

            p.textContent = message;

            if (message.endWith("\n")) {
                p = document.createElement('p');
                console.appendChild(p);
                p.appendChild(document.createTextNode(''));
                p.style.wordWrap = 'break-word';
            }

            console.scrollTop = console.scrollHeight;
        }
    </script>
</head>
<body>
<noscript>
    <h2 style="color: #ff0000">Seems your browser doesn't support Javascript! Websockets
        rely on Javascript being enabled. Please enable
        Javascript and reload this page!</h2></noscript>
<div>
    <div id="connect-container">
        <input id="radio1" type="radio" name="group1" onclick="updateUrl('/websocket');">
        <label for="radio1">W3C WebSocket</label>
        <br>
        <input id="radio2" type="radio" name="group1" onclick="updateUrl('/websocket');">
        <label for="radio2">SockJS</label>

        <div id="sockJsTransportSelect" style="visibility:hidden;">
            <span>SockJS transport:</span>
            <select onchange="updateTransport(this.value)">
                <option value="all">all</option>
                <option value="websocket">websocket</option>
                <option value="xhr-polling">xhr-polling</option>
                <option value="jsonp-polling">jsonp-polling</option>
                <option value="xhr-streaming">xhr-streaming</option>
                <option value="iframe-eventsource">iframe-eventsource</option>
                <option value="iframe-htmlfile">iframe-htmlfile</option>
            </select>
        </div>
        <div>
            <button id="connect" onclick="connect();">Connect</button>
            <button id="disconnect" disabled="disabled" onclick="disconnect();">Disconnect</button>
        </div>
        <div>
            <label for="message">message:</label><textarea id="message" style="width: 350px">Here is a message!</textarea>
        </div>
        <div>
            <button id="echo" onclick="echo();" disabled="disabled">Echo message</button>
        </div>
    </div>
    <div id="console-container">
        <div id="console"></div>
    </div>
</div>
</body>
</html>  
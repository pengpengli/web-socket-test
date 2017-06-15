package com.springapp.mvc;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by gus on 2015/7/16.
 */
public class WebsocketEndPoint extends TextWebSocketHandler {

    private Logger logger = LoggerFactory.getLogger(WebsocketEndPoint.class);

    private Map<String, WebSocketSession> allSession = new HashMap();

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {

        super.handleTextMessage(session, message);

        TextMessage r;
        for (int i = 0; i < 20000; i++) {
            if ((i % 1000) == 0) {
                r = new TextMessage(i + "\n");
            } else {
                r = new TextMessage(i + "\r");
            }
            sendMessage(r);
        }

        sendMessage(new TextMessage("Done.\n"));
    }

    private void sendMessage(TextMessage r) throws IOException, InterruptedException {
        for(Map.Entry entry : allSession.entrySet()) {
            WebSocketSession webSocketSession = (WebSocketSession)entry.getValue();
            webSocketSession.sendMessage(r);
            Thread.sleep(1);
        }
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        logger.info("connection to server: " + session.getId());
        addSession(session);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        logger.info("disconnection to server: " + session.getId());
        delSession(session);
    }

    private synchronized void addSession(WebSocketSession session) {
        allSession.put(session.getId(), session);
    }

    private synchronized void delSession(WebSocketSession session) {
        allSession.remove(session.getId());
    }
}

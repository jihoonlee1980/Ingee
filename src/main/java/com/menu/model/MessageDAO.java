package com.menu.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;

public class MessageDAO extends SqlSessionDaoSupport {
	public int getRecvMessageCount(String id) {
		return getSqlSession().selectOne("getRecvMessageCount" , id);
	}
	
	public List<MessageDTO> getRecvMessageList(HashMap<String, Object> map) {
		
		return getSqlSession().selectList("getRecvMessageList" , map);
		
	}
	
	public int sendMessage(Map<String, Object> map) {
		return getSqlSession().insert("sendMessage", map);
	}
	
	public HashMap<String, Object> getMessageContent(int num) {
		return getSqlSession().selectOne("getMessageContent", num);
	}
	
	public int delteMessage(int num) {
		return getSqlSession().delete("deleteMessage", num);
	}
}

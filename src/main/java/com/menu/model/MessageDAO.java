package com.menu.model;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.support.SqlSessionDaoSupport;

public class MessageDAO extends SqlSessionDaoSupport {
	public int getRecvMessageCount(String id) {
		return getSqlSession().selectOne("getRecvMessageCount" , id);
	}
	
	public List<MessageDTO> getRecvMessageList(HashMap<String, Object> map) {
		
		return getSqlSession().selectList("getRecvMessageList" , map);
		
	}
}

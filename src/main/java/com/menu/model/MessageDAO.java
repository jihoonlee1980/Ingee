package com.menu.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;

public class MessageDAO extends SqlSessionDaoSupport {
	public int getRecvMessageCount(Map<String, Object> map) {
		return getSqlSession().selectOne("getRecvMessageCount" , map);
	}
	
	public List<MessageDTO> getRecvMessageList(HashMap<String, Object> map) {
		
		return getSqlSession().selectList("getRecvMessageList" , map);
		
	}
	
	public int sendMessage(Map<String, Object> map) {
		int result = 0;
		if(map.get("DISC").toString().equals("single"))
			result = getSqlSession().insert("sendMessage", map);
		else if(map.get("DISC").toString().equals("all")){
			List<HashMap<String, Object>> resultMap = getSqlSession().selectList("getMemberSendMessageRecvId", map.get("id"));
			for (HashMap<String, Object> getMap : resultMap) {
				map.put("receiver",getMap.get("id").toString());
				result += getSqlSession().insert("sendMessage", map);
			}
		}
		else{			
			String[] recvArr = map.get("recvlist").toString().split(",");
			for(int i=0; i<recvArr.length; i++){
			    //System.out.println(i+"= "+recvArr[i]);
			    map.put("receiver",recvArr[i]);
			    result += getSqlSession().insert("sendMessage", map);
			}
		}
		return result;
	}
	
	public HashMap<String, Object> getMessageContent(int num) {
		return getSqlSession().selectOne("getMessageContent", num);
	}
	
	public int delteMessage(int num) {
		return getSqlSession().delete("deleteMessage", num);
	}
	
	public List<String> checkId(List<String> id) {
		List<String> ids = new ArrayList<String>();
		for (String getId : id) {
			if(getSqlSession().selectOne("messageIdcheck" , getId)==null)
				ids.add(getId);
		}		
		return ids;
	}
}

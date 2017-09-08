package com.menu.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;

public class MemberDAO extends SqlSessionDaoSupport {
	public int getCount() {
		return getSqlSession().selectOne("countMember");
	}

	public int getCount(String search_type, String keyword) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("search_type", search_type);
		map.put("keyword", keyword);

		return getSqlSession().selectOne("countSearchMember", map);
	}

	public List<MemberDTO> list(int startNum, int perPage, String sort) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("start", startNum);
		map.put("perPage", perPage);
		map.put("sort", sort);

		return getSqlSession().selectList("memberList", map);
	}

	public List<MemberDTO> searchList(int start, int perPage, String sort, String search_type, String keyword) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("start", start);
		map.put("perPage", perPage);
		map.put("sort", sort);
		map.put("search_type", search_type);
		map.put("keyword", keyword);

		return getSqlSession().selectList("searchMemberList", map);
	}

	public void insert(MemberDTO memberDTO) {
		getSqlSession().insert("inserMember", memberDTO);
	}

	public MemberDTO get(int num) {
		return getSqlSession().selectOne("getMemberNum", num);
	}

	public MemberDTO get(String id) {
		return getSqlSession().selectOne("getMemberID", id);
	}

	public MemberDTO update(MemberDTO memberDTO, String type) {
		if ("profile".equals(type))
			getSqlSession().update("updateProfile", memberDTO);
		else if ("pass".equals(type))
			getSqlSession().update("updatePass", memberDTO);

		return getSqlSession().selectOne("getMemberNum", memberDTO.num);
	}

	public void delete(int num, String id) {
		// getSqlSession().delete("deleteWriterCascade", id);
		getSqlSession().delete("deleteMember", num);
	}

//	public int checkMemberUsername(String username) {
//		return getSqlSession().selectOne("checkMemberUsername", username);
//	}
//
//	public int checkMemberFilename(String saved_filename) {
//		return getSqlSession().selectOne("checkMemberFilename", saved_filename);
//	}

	public MemberDTO login(MemberDTO memberDTO) {
		return getSqlSession().selectOne("loginMember", memberDTO);
	}

	public boolean checkPass(int num, String pass) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("num", num);
		map.put("pass", pass);

		return getSqlSession().selectOne("checkPass", map) != null;
	}

	public boolean find(String column, Object value) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("column", column);
		map.put("value", value);

		return getSqlSession().selectOne("findMember", map) != null;
	}
}

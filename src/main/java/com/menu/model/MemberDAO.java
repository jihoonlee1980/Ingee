package com.menu.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.transaction.annotation.Transactional;

@Transactional
public class MemberDAO extends SqlSessionDaoSupport {
	public int getCount(String region) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("region", region);

		return getSqlSession().selectOne("countMember", map);
	}

	public int getCount(String search_type, String keyword, String region) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("search_type", search_type);
		map.put("keyword", keyword);
		map.put("region", region);

		return getSqlSession().selectOne("countSearchMember", map);
	}

	public List<MemberDTO> list(int startNum, int perPage, String sort, String region) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("start", startNum);
		map.put("perPage", perPage);
		map.put("sort", sort);
		map.put("region", region);

		return getSqlSession().selectList("memberList", map);
	}

	public List<MemberDTO> searchList(int start, int perPage, String sort, String search_type, String keyword,
			String region) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("start", start);
		map.put("perPage", perPage);
		map.put("sort", sort);
		map.put("search_type", search_type);
		map.put("keyword", keyword);
		map.put("region", region);

		return getSqlSession().selectList("searchMemberList", map);
	}

	public void insert(MemberDTO memberDTO) {
		getSqlSession().insert("insertMember", memberDTO);
	}

	public MemberDTO get(int num) {
		return getSqlSession().selectOne("getMemberNum", num);
	}

	public MemberDTO get(String id) {
		return getSqlSession().selectOne("getMemberID", id);
	}

	public void updateNick(String current_nick, String new_nick) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("current_nick", current_nick);
		map.put("new_nick", new_nick);

		getSqlSession().update("updateNickCascade", map);
	}

	public MemberDTO update(MemberDTO memberDTO, String type) {
		if ("profile".equals(type))
			getSqlSession().update("updateProfile", memberDTO);
		else if ("pass".equals(type))
			getSqlSession().update("updatePass", memberDTO);

		return getSqlSession().selectOne("getMemberNum", memberDTO.num);
	}

	public void delete(int num, String nick) {
		getSqlSession().delete("withdrawalDelete", nick);
		getSqlSession().delete("deleteMemberCascade", nick);
		getSqlSession().delete("deleteMember", num);
	}

	public MemberDTO login(MemberDTO memberDTO) {
		return getSqlSession().selectOne("loginMember", memberDTO);
	}

	public boolean checkPass(int num, String pass) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("num", num);
		map.put("pass", pass);

		return getSqlSession().selectOne("checkPass", map) != null;
	}

	public MemberDTO find(String column, Object value) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("column", column);
		map.put("value", value);

		return getSqlSession().selectOne("findMember", map);
	}

	public MemberDTO joinComplete(String id, String complete_key) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("id", id);
		map.put("complete_key", complete_key);

		MemberDTO memberDTO = getSqlSession().selectOne("joinComplete", map);

		if (memberDTO != null)
			getSqlSession().update("updateVerfication", id);

		return memberDTO;
	}

	public List<Integer> expireMemberNum() {
		return getSqlSession().selectList("expireMemberNum");
	}

	public void expireVerificationMail() {
		getSqlSession().delete("expireVerificationMail");
	}
}

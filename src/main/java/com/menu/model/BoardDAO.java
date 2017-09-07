package com.menu.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;

public class BoardDAO extends SqlSessionDaoSupport {
	public List<BoardDTO> list(int start, int perPage, String b_category, String s_category) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("start", start);
		map.put("perPage", perPage);
		map.put("b_category", b_category);
		map.put("s_category", s_category);

		return getSqlSession().selectList("boardList", map);
	}

	public int getCount(String b_category, String s_category) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("b_category", b_category);
		map.put("s_category", s_category);

		return getSqlSession().selectOne("boardCount", map);
	}
}

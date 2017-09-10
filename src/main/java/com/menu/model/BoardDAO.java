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
	
	public List<BoardDTO> list(int start, int perPage, String b_category, String s_category, String search_type, String keyword) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("start", start);
		map.put("perPage", perPage);
		map.put("b_category", b_category);
		map.put("s_category", s_category);
		map.put("search_type", search_type);
		map.put("keyword", keyword);

		return getSqlSession().selectList("boardList", map);
	}

	public void insert(BoardDTO boardDTO) {
		getSqlSession().insert("insertBoard", boardDTO);
	}

	public BoardDTO get(int board_num) {
		return getSqlSession().selectOne("getBoard", board_num);
	}

	public void update(BoardDTO boardDTO) {
		getSqlSession().delete("updateBoard", boardDTO);
	}

	public void delete(int board_num) {
		getSqlSession().delete("deleteBoard", board_num);
	}

	public int getCount(String b_category, String s_category) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("b_category", b_category);
		map.put("s_category", s_category);

		return getSqlSession().selectOne("boardCount", map);
	}
	
	public int getCount(String b_category, String s_category,  String search_type, String keyword) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("b_category", b_category);
		map.put("s_category", s_category);
		map.put("search_type", search_type);
		map.put("keyword", keyword);

		return getSqlSession().selectOne("boardCount", map);
	}

	public BoardDTO updateReadCount(int board_num) {
		getSqlSession().update("updateReadCount", board_num);
		return getSqlSession().selectOne("getBoard", board_num);
	}

	public boolean find(String column, Object value) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("column", column);
		map.put("value", value);

		return getSqlSession().selectOne("findBoard", map) != null;
	}
}

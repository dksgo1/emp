<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.HashMap"%>
<%@ page import = "java.util.ArrayList" %>
<%
	// Map 타입의 이해
	// Class 사용 하면
	/*
	학생이 한명일때
	Class Student {
		public String name;
		public int age;
	}

	Student s = new Student();
	s.name = "김땡떙";
	s.age = 29;
	*/
	
	// Student Class가 없다면 - 클래스를 사용하지 않는 방법
	HashMap<String, Object> m = new HashMap<String, Object>();
	m.put("name", "김땡떙");
	m.put("age", 29);
	System.out.println(m.get("name"));
	System.out.println(m.get("age"));
	
	// 배열 집합이면
	/*
	Student s1 = new Student();
	s1.name = "이땡땡";
	s1.age = 26;
	Student s2 = new Student();
	s2.name = "박땡떙";
	s2.age = 29;
	ArrayList<Student> studentList =new ArrayList<Student>();
	studentList.add(s1);
	studentList.add(s2);
	System.out.println("studentList 출력");
	for(Student st : studentList) {
		System.out.println(st.name);
		System.out.println(st.age);
	}
	*/
	
	// 2) Map 사용
	HashMap<String, Object> m1 = new HashMap<String, Object>();
	m1.put("name", "이땡떙");
	m1.put("age", 26);
	HashMap<String, Object> m2 = new HashMap<String, Object>();
	m2.put("name", "박땡떙");
	m2.put("age", 29);
	ArrayList<HashMap<String, Object>> mapList = new ArrayList<HashMap<String, Object>>();
	mapList.add(m1);
	mapList.add(m2);
	for(HashMap<String, Object> hm : mapList ) {
		System.out.println(hm.get("name"));
		System.out.println(hm.get("age"));
		
	}
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>
-- ============================================================
-- Coding Questions Seed + Exam Settings Fix
-- 30 coding questions per exam, TotalQuestions=20, last 2 = coding
-- Run against EDTech database
-- ============================================================
SET FOREIGN_KEY_CHECKS=0;

-- Step 1: Fix all existing exams to show 20 questions
UPDATE MockTests SET TotalQuestions=20, RandomizeQuestions=0 WHERE TotalQuestions>20 OR TotalQuestions=0;


-- ═══ Python Full Stack — Coding Questions ═══
SET @tid = (SELECT Id FROM MockTests WHERE Title='Python Full Stack Assessment' ORDER BY Id LIMIT 1);
SET @baseOrder = (SELECT COALESCE(MAX(DisplayOrder),17) FROM MockTestQuestions WHERE MockTestId=@tid);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Reverse a String','Python',1,7,10,0,@baseOrder+1);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given a string <code>s</code>, return its reverse.</p>','1 <= len(s) <= 1000','hello','olleh','s = input()
print(s[::-1])','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;reverse(s.begin(),s.end());cout<<s;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);String s=sc.next();System.out.println(new StringBuilder(s).reverse());}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log(l.trim().split('''').reverse().join(''''));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello','olleh',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'racecar','racecar',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'python','nohtyp',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'abcde','edcba',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Count Vowels','Python',1,7,10,0,@baseOrder+2);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Count the number of vowels (a,e,i,o,u) in a string (case-insensitive).</p>','1 <= len(s) <= 1000','Hello World','3','s=input().lower()
print(sum(1 for c in s if c in ''aeiou''))','#include<bits/stdc++.h>
using namespace std;
int main(){string s;getline(cin,s);int c=0;for(char x:s){x=tolower(x);if(string("aeiou").find(x)!=string::npos)c++;}cout<<c;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);String s=sc.nextLine().toLowerCase();long c=s.chars().filter(x->"aeiou".indexOf(x)>=0).count();System.out.println(c);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log([...l.toLowerCase()].filter(c=>''aeiou''.includes(c)).length);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Hello World','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Python','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'AEIOU','5',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'rhythm','0',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Fibonacci','Python',1,7,10,0,@baseOrder+3);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print the first <code>n</code> Fibonacci numbers, space-separated.</p>','1 <= n <= 30','7','0 1 1 2 3 5 8','n=int(input())
a,b=0,1
res=[]
for _ in range(n):
    res.append(a)
    a,b=b,a+b
print(*res)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;long long a=0,b=1;for(int i=0;i<n;i++){cout<<a;if(i<n-1)cout<<" ";long long c=a+b;a=b;b=c;}}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();long x=0,y=1;StringBuilder sb=new StringBuilder();for(int i=0;i<n;i++){if(i>0)sb.append(" ");sb.append(x);long z=x+y;x=y;y=z;}System.out.println(sb);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;let a=0,b=1,r=[];for(let i=0;i<n;i++){r.push(a);[a,b]=[b,a+b];}console.log(r.join('' ''));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'7','0 1 1 2 3 5 8',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','0',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'10','0 1 1 2 3 5 8 13 21 34',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5','0 1 1 2 3',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Palindrome Check','Python',1,7,10,0,@baseOrder+4);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print <code>YES</code> if string is palindrome else <code>NO</code>.</p>','1 <= len(s) <= 1000','racecar','YES','s=input().strip()
print(''YES'' if s==s[::-1] else ''NO'')','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;string r=s;reverse(r.begin(),r.end());cout<<(s==r?"YES":"NO");}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();System.out.println(s.equals(new StringBuilder(s).reverse().toString())?"YES":"NO");}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const s=l.trim();console.log(s===s.split('''').reverse().join('''')?''YES'':''NO'');rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'racecar','YES',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello','NO',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'madam','YES',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'level','YES',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Two Sum','Python',1,7,10,0,@baseOrder+5);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given array of integers and a target, print indices of two numbers that sum to target.</p><p>Line 1: n, Line 2: n numbers, Line 3: target</p>','2 <= n <= 10^4','4
2 7 11 15
9','0 1','n=int(input())
nums=list(map(int,input().split()))
t=int(input())
seen={}
for i,x in enumerate(nums):
    if t-x in seen:
        print(seen[t-x],i)
        break
    seen[x]=i','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int t;cin>>t;map<int,int>m;for(int i=0;i<n;i++){if(m.count(t-a[i])){cout<<m[t-a[i]]<<" "<<i;return 0;}m[a[i]]=i;}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();int t=sc.nextInt();Map<Integer,Integer>m=new HashMap<>();for(int i=0;i<n;i++){if(m.containsKey(t-arr[i])){System.out.println(m.get(t-arr[i])+" "+i);return;}m.put(arr[i],i);}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const nums=L[1].split('' '').map(Number);const t=+L[2];const m={};for(let i=0;i<nums.length;i++){if(m[t-nums[i]]!==undefined){console.log(m[t-nums[i]]+'' ''+i);return;}m[nums[i]]=i;}});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
2 7 11 15
9','0 1',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
3 2 4
6','1 2',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
3 3
6','0 1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'FizzBuzz','Python',1,7,10,0,@baseOrder+6);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>For 1 to n: print Fizz (div by 3), Buzz (div by 5), FizzBuzz (both), else number.</p>','1 <= n <= 1000','5','1
2
Fizz
4
Buzz','n=int(input())
for i in range(1,n+1):
    if i%15==0:print(''FizzBuzz'')
    elif i%3==0:print(''Fizz'')
    elif i%5==0:print(''Buzz'')
    else:print(i)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;for(int i=1;i<=n;i++){if(i%15==0)cout<<"FizzBuzz\n";else if(i%3==0)cout<<"Fizz\n";else if(i%5==0)cout<<"Buzz\n";else cout<<i<<"\n";}}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();for(int i=1;i<=n;i++){if(i%15==0)System.out.println("FizzBuzz");else if(i%3==0)System.out.println("Fizz");else if(i%5==0)System.out.println("Buzz");else System.out.println(i);}}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;for(let i=1;i<=n;i++){if(i%15===0)console.log(''FizzBuzz'');else if(i%3===0)console.log(''Fizz'');else if(i%5===0)console.log(''Buzz'');else console.log(i);}rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5','1
2
Fizz
4
Buzz',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'15','1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3','1
2
Fizz',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Max in Array','Python',1,7,10,0,@baseOrder+7);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find maximum value in an array. Line 1: n, Line 2: n integers.</p>','1 <= n <= 10^5','5
3 1 4 1 5','5','n=int(input())
print(max(map(int,input().split())))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;int mx=INT_MIN;for(int i=0;i<n;i++){int x;cin>>x;mx=max(mx,x);}cout<<mx;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int mx=Integer.MIN_VALUE;while(n-->0){int x=sc.nextInt();mx=Math.max(mx,x);}System.out.println(mx);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{console.log(Math.max(...L[1].split('' '').map(Number)));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
3 1 4 1 5','5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
-1 -5 -2','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
0 0 0 1','1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Sum of Digits','Python',1,7,10,0,@baseOrder+8);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given a non-negative integer, print the sum of its digits.</p>','0 <= n <= 10^18','1234','10','print(sum(int(c) for c in input().strip()))','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;int t=0;for(char c:s)t+=c-''0'';cout<<t;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();int t=0;for(char c:s.toCharArray())t+=c-''0'';System.out.println(t);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log([...l.trim()].reduce((s,c)=>s+parseInt(c),0));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1234','10',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'999','27',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'0','0',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'100','1',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Prime Check','Python',1,7,10,0,@baseOrder+9);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print <code>PRIME</code> or <code>NOT PRIME</code>.</p>','1 <= n <= 10^6','17','PRIME','n=int(input())
if n<2:print(''NOT PRIME'')
else:print(''PRIME'' if all(n%i!=0 for i in range(2,int(n**0.5)+1)) else ''NOT PRIME'')','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;if(n<2){cout<<"NOT PRIME";return 0;}for(int i=2;i*i<=n;i++)if(n%i==0){cout<<"NOT PRIME";return 0;}cout<<"PRIME";}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();if(n<2){System.out.println("NOT PRIME");return;}for(int i=2;i*i<=n;i++)if(n%i==0){System.out.println("NOT PRIME");return;}System.out.println("PRIME");}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;if(n<2){console.log(''NOT PRIME'');rl.close();return;}for(let i=2;i*i<=n;i++)if(n%i===0){console.log(''NOT PRIME'');rl.close();return;}console.log(''PRIME'');rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'17','PRIME',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4','NOT PRIME',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','NOT PRIME',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'97','PRIME',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Factorial','Python',1,7,10,0,@baseOrder+10);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print n! (n <= 15).</p>','0 <= n <= 15','5','120','import math
print(math.factorial(int(input())))','#include<bits/stdc++.h>
using namespace std;
int main(){long long n,f=1;cin>>n;for(long long i=1;i<=n;i++)f*=i;cout<<f;}','import java.util.*;
public class Solution{public static void main(String[] a){long n=new Scanner(System.in).nextLong();long f=1;for(long i=1;i<=n;i++)f*=i;System.out.println(f);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{let n=+l,f=1;for(let i=1;i<=n;i++)f*=i;console.log(f);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5','120',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'0','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'10','3628800',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'12','479001600',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Binary Search','Python',1,7,10,0,@baseOrder+11);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given sorted array and target, print index (0-based) or -1 if not found.</p><p>Line 1: n, Line 2: sorted integers, Line 3: target</p>','1 <= n <= 10^5','5
1 3 5 7 9
7','3','n=int(input())
arr=list(map(int,input().split()))
t=int(input())
l,r=0,n-1
while l<=r:
    m=(l+r)//2
    if arr[m]==t:print(m);exit()
    elif arr[m]<t:l=m+1
    else:r=m-1
print(-1)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int t;cin>>t;int l=0,r=n-1;while(l<=r){int m=(l+r)/2;if(a[m]==t){cout<<m;return 0;}else if(a[m]<t)l=m+1;else r=m-1;}cout<<-1;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();int t=sc.nextInt(),l=0,r=n-1;while(l<=r){int m=(l+r)/2;if(arr[m]==t){System.out.println(m);return;}else if(arr[m]<t)l=m+1;else r=m-1;}System.out.println(-1);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);const t=+L[2];let l=0,r=a.length-1;while(l<=r){const m=Math.floor((l+r)/2);if(a[m]===t){console.log(m);return;}else if(a[m]<t)l=m+1;else r=m-1;}console.log(-1);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
1 3 5 7 9
7','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 2 3
4','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6
2 4 6 8 10 12
10','4',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Word Count','Python',1,7,10,0,@baseOrder+12);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print the number of words in a sentence.</p>','1 <= len(s) <= 1000','Hello World how are you','5','print(len(input().split()))','#include<bits/stdc++.h>
using namespace std;
int main(){string line;getline(cin,line);istringstream iss(line);int c=0;string w;while(iss>>w)c++;cout<<c;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).nextLine().trim();System.out.println(s.isEmpty()?0:s.split("\\s+").length);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log(l.trim().split(/\s+/).filter(Boolean).length);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Hello World how are you','5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'one','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Python is awesome','3',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Anagram Check','Python',1,7,10,0,@baseOrder+13);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given two strings on separate lines, print YES if anagrams else NO (case-insensitive).</p>','1 <= len <= 1000','listen
silent','YES','a,b=input().lower(),input().lower()
print(''YES'' if sorted(a)==sorted(b) else ''NO'')','#include<bits/stdc++.h>
using namespace std;
int main(){string a,b;cin>>a>>b;for(auto&c:a)c=tolower(c);for(auto&c:b)c=tolower(c);sort(a.begin(),a.end());sort(b.begin(),b.end());cout<<(a==b?"YES":"NO");}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);char[]x=sc.next().toLowerCase().toCharArray();char[]y=sc.next().toLowerCase().toCharArray();Arrays.sort(x);Arrays.sort(y);System.out.println(Arrays.equals(x,y)?"YES":"NO");}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim().toLowerCase()));rl.on(''close'',()=>{console.log([...L[0]].sort().join('''')===[...L[1]].sort().join('''')?''YES'':''NO'');});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'listen
silent','YES',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello
world','NO',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'triangle
integral','YES',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Largest Palindrome Substring Length','Python',1,7,10,0,@baseOrder+14);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find the length of the longest palindromic substring.</p>','1 <= len(s) <= 1000','babad','3','s=input().strip()
n=len(s)
best=1
for i in range(n):
    for r in range(2):
        l,ri=i,i+r
        while l>=0 and ri<n and s[l]==s[ri]:
            best=max(best,ri-l+1)
            l-=1;ri+=1
print(best)','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;int n=s.size(),best=1;for(int i=0;i<n;i++)for(int r=0;r<2;r++){int l=i,ri=i+r;while(l>=0&&ri<n&&s[l]==s[ri]){best=max(best,ri-l+1);l--;ri++;}}cout<<best;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();int n=s.length(),best=1;for(int i=0;i<n;i++)for(int r=0;r<2;r++){int l=i,ri=i+r;while(l>=0&&ri<n&&s.charAt(l)==s.charAt(ri)){best=Math.max(best,ri-l+1);l--;ri++;}}System.out.println(best);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const s=l.trim();let best=1;for(let i=0;i<s.length;i++)for(let r=0;r<2;r++){let[L,ri]=[i,i+r];while(L>=0&&ri<s.length&&s[L]===s[ri]){best=Math.max(best,ri-L+1);L--;ri++;}}console.log(best);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'babad','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'cbbd','2',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'racecar','7',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Sum of Array','Python',1,7,10,0,@baseOrder+15);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print sum of n integers. Line 1: n, Line 2: n numbers.</p>','1 <= n <= 10^5','5
1 2 3 4 5','15','n=int(input())
print(sum(map(int,input().split())))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;long long s=0;for(int i=0;i<n;i++){int x;cin>>x;s+=x;}cout<<s;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();long s=0;while(n-->0)s+=sc.nextLong();System.out.println(s);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{console.log(L[1].split('' '').reduce((a,b)=>a+ +b,0));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
1 2 3 4 5','15',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
-1 0 1','0',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1
100','100',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Count Words Starting With Vowel','Python',1,7,10,0,@baseOrder+16);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Count words in sentence that start with a vowel (case-insensitive).</p>','1 <= len(s) <= 1000','apple is an orange','3','s=input().lower()
print(sum(1 for w in s.split() if w[0] in ''aeiou''))','#include<bits/stdc++.h>
using namespace std;
int main(){string line;getline(cin,line);istringstream iss(line);string w;int c=0;while(iss>>w){char ch=tolower(w[0]);if(string("aeiou").find(ch)!=string::npos)c++;}cout<<c;}','import java.util.*;
public class Solution{public static void main(String[] a){String[]ws=new Scanner(System.in).nextLine().toLowerCase().split("\\s+");long c=Arrays.stream(ws).filter(w->"aeiou".indexOf(w.charAt(0))>=0).count();System.out.println(c);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log(l.toLowerCase().split(/\s+/).filter(w=>''aeiou''.includes(w[0])).length);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'apple is an orange','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello world','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Every Algorithm Is Optimal','4',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'GCD of Two Numbers','Python',1,7,10,0,@baseOrder+17);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print GCD of two space-separated integers.</p>','1 <= a,b <= 10^9','12 8','4','a,b=map(int,input().split())
from math import gcd
print(gcd(a,b))','#include<bits/stdc++.h>
using namespace std;
int main(){long long a,b;cin>>a>>b;cout<<__gcd(a,b);}','import java.util.*;
public class Solution{static long gcd(long a,long b){return b==0?a:gcd(b,a%b);}public static void main(String[] a){Scanner sc=new Scanner(System.in);System.out.println(gcd(sc.nextLong(),sc.nextLong()));}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const[a,b]=l.split('' '').map(Number);const g=(x,y)=>y===0?x:g(y,x%y);console.log(g(a,b));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'12 8','4',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'100 75','25',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'17 13','1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Second Largest','Python',1,7,10,0,@baseOrder+18);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find the second largest unique element. Print -1 if none.</p><p>Line 1: n, Line 2: n integers.</p>','2 <= n <= 10^5','5
3 1 4 1 5','4','n=int(input())
nums=list(map(int,input().split()))
uniq=sorted(set(nums))
print(uniq[-2] if len(uniq)>=2 else -1)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;set<int>s;for(int i=0;i<n;i++){int x;cin>>x;s.insert(x);}auto it=s.end();--it;if(it==s.begin())cout<<-1;else{--it;cout<<*it;}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();TreeSet<Integer>s=new TreeSet<>();while(n-->0)s.add(sc.nextInt());if(s.size()<2)System.out.println(-1);else{s.pollLast();System.out.println(s.last());}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const s=[...new Set(L[1].split('' '').map(Number))].sort((a,b)=>a-b);console.log(s.length>=2?s[s.length-2]:-1);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
3 1 4 1 5','4',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
5 5 5','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
10 20 30 40','30',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Remove Duplicates','Python',1,7,10,0,@baseOrder+19);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print unique elements in original order, space-separated.</p><p>Line 1: n, Line 2: n integers.</p>','1 <= n <= 10^5','6
1 2 2 3 1 4','1 2 3 4','n=int(input())
nums=list(map(int,input().split()))
seen=set()
res=[]
for x in nums:
    if x not in seen:
        res.append(x)
        seen.add(x)
print(*res)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;set<int>seen;bool first=true;for(int x:a){if(!seen.count(x)){if(!first)cout<<" ";cout<<x;first=false;seen.insert(x);}}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();LinkedHashSet<Integer>s=new LinkedHashSet<>();while(n-->0)s.add(sc.nextInt());System.out.println(s.toString().replaceAll("[\\[\\],]","").trim());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const seen=new Set();console.log(L[1].split('' '').map(Number).filter(x=>!seen.has(x)&&seen.add(x)).join('' ''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6
1 2 2 3 1 4','1 2 3 4',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
5 5 5','5',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
3 1 4 1 5','3 1 4 5',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Longest Common Prefix','Python',1,7,10,0,@baseOrder+20);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find longest common prefix of n strings.</p><p>Line 1: n, then n strings.</p>','1 <= n <= 100','3
flower
flow
flight','fl','n=int(input())
words=[input() for _ in range(n)]
p=words[0]
for w in words[1:]:
    while not w.startswith(p):p=p[:-1]
print(p)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<string>v(n);for(auto&s:v)cin>>s;string p=v[0];for(int i=1;i<n;i++){while(v[i].find(p)!=0){p=p.substr(0,p.size()-1);if(p.empty()){cout<<"";return 0;}}}cout<<p;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();String[]w=new String[n];for(int i=0;i<n;i++)w[i]=sc.next();String p=w[0];for(int i=1;i<n;i++){while(!w[i].startsWith(p)){p=p.substring(0,p.length()-1);if(p.isEmpty()){System.out.println("");return;}}}System.out.println(p);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const n=+L[0];const words=L.slice(1,n+1);let p=words[0];for(let i=1;i<words.length;i++){while(!words[i].startsWith(p)){p=p.slice(0,-1);if(!p){console.log('''');return;}}}console.log(p);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
flower
flow
flight','fl',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
dog
racecar','',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1
hello','hello',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Count Occurrences','Python',1,7,10,0,@baseOrder+21);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Count how many times a character appears in string (case-sensitive).</p><p>Line 1: string, Line 2: character</p>','1 <= len(s) <= 1000','hello
l','2','s=input()
c=input()
print(s.count(c))','#include<bits/stdc++.h>
using namespace std;
int main(){string s,c;getline(cin,s);getline(cin,c);cout<<count(s.begin(),s.end(),c[0]);}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);String s=sc.nextLine();char c=sc.nextLine().charAt(0);System.out.println(s.chars().filter(x->x==c).count());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l));rl.on(''close'',()=>{const[s,c]=L;console.log([...s].filter(x=>x===c[0]).length);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello
l','2',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'programming
g','2',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'aaaaaa
a','6',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Matrix Diagonal Sum','Python',1,7,10,0,@baseOrder+22);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print sum of main diagonal elements of n×n matrix.</p><p>Line 1: n, then n lines of n integers.</p>','1 <= n <= 100','3
1 2 3
4 5 6
7 8 9','15','n=int(input())
m=[list(map(int,input().split())) for _ in range(n)]
print(sum(m[i][i] for i in range(n)))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<vector<int>>m(n,vector<int>(n));for(auto&r:m)for(auto&x:r)cin>>x;long long s=0;for(int i=0;i<n;i++)s+=m[i][i];cout<<s;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();long s=0;for(int i=0;i<n;i++){for(int j=0;j<n;j++){int x=sc.nextInt();if(i==j)s+=x;}}System.out.println(s);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const n=+L[0];let s=0;for(let i=0;i<n;i++){const r=L[i+1].split('' '').map(Number);s+=r[i];}console.log(s);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 2 3
4 5 6
7 8 9','15',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
1 2
3 4','5',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
1 0 0 0
0 2 0 0
0 0 3 0
0 0 0 4','10',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Bubble Sort','Python',1,7,10,0,@baseOrder+23);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Sort n integers using Bubble Sort, print sorted array space-separated.</p>','1 <= n <= 1000','5
5 3 1 4 2','1 2 3 4 5','n=int(input())
a=list(map(int,input().split()))
for i in range(n):
    for j in range(n-i-1):
        if a[j]>a[j+1]:a[j],a[j+1]=a[j+1],a[j]
print(*a)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;for(int i=0;i<n;i++)for(int j=0;j<n-i-1;j++)if(a[j]>a[j+1])swap(a[j],a[j+1]);for(int i=0;i<n;i++){if(i)cout<<" ";cout<<a[i];}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();for(int i=0;i<n;i++)for(int j=0;j<n-i-1;j++)if(arr[j]>arr[j+1]){int t=arr[j];arr[j]=arr[j+1];arr[j+1]=t;}System.out.println(Arrays.stream(arr).mapToObj(Integer::toString).reduce((x,y)->x+" "+y).get());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);for(let i=0;i<a.length;i++)for(let j=0;j<a.length-i-1;j++)if(a[j]>a[j+1])[a[j],a[j+1]]=[a[j+1],a[j]];console.log(a.join('' ''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
5 3 1 4 2','1 2 3 4 5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
3 1 2','1 2 3',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
4 3 2 1','1 2 3 4',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Stack using List','Python',1,7,10,0,@baseOrder+24);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Simulate a stack. Line 1: q queries. Each query: PUSH x or POP (print popped, or -1 if empty).</p>','1 <= q <= 1000','4
PUSH 5
PUSH 3
POP
POP','3
5','q=int(input())
stack=[]
for _ in range(q):
    line=input().split()
    if line[0]==''PUSH'':stack.append(int(line[1]))
    else:print(stack.pop() if stack else -1)','#include<bits/stdc++.h>
using namespace std;
int main(){int q;cin>>q;cin.ignore();stack<int>st;while(q--){string line;getline(cin,line);if(line[0]==''P''&&line[1]==''U''){st.push(stoi(line.substr(5)));}else{if(st.empty())cout<<-1<<"\n";else{cout<<st.top()<<"\n";st.pop();}}}}
','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int q=sc.nextInt();sc.nextLine();Deque<Integer>stack=new ArrayDeque<>();while(q-->0){String[]l=sc.nextLine().split(" ");if(l[0].equals("PUSH"))stack.push(Integer.parseInt(l[1]));else System.out.println(stack.isEmpty()?-1:stack.pop());}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const stack=[];const out=[];for(let i=1;i<L.length;i++){const p=L[i].split('' '');if(p[0]===''PUSH'')stack.push(+p[1]);else out.push(stack.length?stack.pop():-1);}console.log(out.join(''\n''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
PUSH 5
PUSH 3
POP
POP','3
5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
POP
PUSH 1','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
PUSH 10
PUSH 20
POP','20',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Pattern - Right Triangle','Python',1,7,10,0,@baseOrder+25);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print a right triangle of stars of height n.</p>','1 <= n <= 20','4','*
**
***
****','n=int(input())
for i in range(1,n+1):print(''*''*i)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;for(int i=1;i<=n;i++){for(int j=0;j<i;j++)cout<<''*'';cout<<"\n";}}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();for(int i=1;i<=n;i++){System.out.println("*".repeat(i));}}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;for(let i=1;i<=n;i++)console.log(''*''.repeat(i));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4','*
**
***
****',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','*',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3','*
**
***',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Kadane''s Algorithm','Python',1,7,10,0,@baseOrder+26);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find maximum subarray sum.</p><p>Line 1: n, Line 2: n integers.</p>','1 <= n <= 10^5','6
-2 1 -3 4 -1 2','5','n=int(input())
a=list(map(int,input().split()))
cur=best=a[0]
for x in a[1:]:
    cur=max(x,cur+x)
    best=max(best,cur)
print(best)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int cur=a[0],best=a[0];for(int i=1;i<n;i++){cur=max(a[i],cur+a[i]);best=max(best,cur);}cout<<best;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();int cur=arr[0],best=arr[0];for(int i=1;i<n;i++){cur=Math.max(arr[i],cur+arr[i]);best=Math.max(best,cur);}System.out.println(best);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);let cur=a[0],best=a[0];for(let i=1;i<a.length;i++){cur=Math.max(a[i],cur+a[i]);best=Math.max(best,cur);}console.log(best);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6
-2 1 -3 4 -1 2','5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
1 2 3 4','10',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
-1 -2 -3','-1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Even or Odd Batch','Python',1,7,10,0,@baseOrder+27);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Line 1: n. For each of next n lines, print EVEN or ODD.</p>','1 <= n <= 100','3
2
7
10','EVEN
ODD
EVEN','n=int(input())
for _ in range(n):
    x=int(input())
    print(''EVEN'' if x%2==0 else ''ODD'')','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;while(n--){int x;cin>>x;cout<<(x%2==0?"EVEN":"ODD")<<"\n";}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();while(n-->0){int x=sc.nextInt();System.out.println(x%2==0?"EVEN":"ODD");}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const n=+L[0];for(let i=1;i<=n;i++)console.log(+L[i]%2===0?''EVEN'':''ODD'');});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
2
7
10','EVEN
ODD
EVEN',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1
0','EVEN',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
-3
4','ODD
EVEN',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Roman to Integer','Python',1,7,10,0,@baseOrder+28);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Convert Roman numeral string to integer.</p>','1 <= len(s) <= 15, valid Roman','XIV','14','s=input().strip()
v={''I'':1,''V'':5,''X'':10,''L'':50,''C'':100,''D'':500,''M'':1000}
res=0
for i in range(len(s)):
    if i+1<len(s) and v[s[i]]<v[s[i+1]]:res-=v[s[i]]
    else:res+=v[s[i]]
print(res)','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;map<char,int>v={{''I'',1},{''V'',5},{''X'',10},{''L'',50},{''C'',100},{''D'',500},{''M'',1000}};int res=0;for(int i=0;i<s.size();i++){if(i+1<s.size()&&v[s[i]]<v[s[i+1]])res-=v[s[i]];else res+=v[s[i]];}cout<<res;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();Map<Character,Integer>v=new HashMap<>();v.put(''I'',1);v.put(''V'',5);v.put(''X'',10);v.put(''L'',50);v.put(''C'',100);v.put(''D'',500);v.put(''M'',1000);int res=0;for(int i=0;i<s.length();i++){if(i+1<s.length()&&v.get(s.charAt(i))<v.get(s.charAt(i+1)))res-=v.get(s.charAt(i));else res+=v.get(s.charAt(i));}System.out.println(res);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const v={I:1,V:5,X:10,L:50,C:100,D:500,M:1000};let res=0;for(let i=0;i<l.length;i++){if(i+1<l.length&&v[l[i]]<v[l[i+1]])res-=v[l[i]];else res+=v[l[i]];}console.log(res);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'XIV','14',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'IX','9',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'MCMXCIV','1994',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Merge Sorted Arrays','Python',1,7,10,0,@baseOrder+29);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Merge two sorted arrays into one sorted array.</p><p>Line 1: n, Line 2: n numbers, Line 3: m, Line 4: m numbers</p>','1 <= n,m <= 10^5','3
1 3 5
3
2 4 6','1 2 3 4 5 6','n=int(input())
a=list(map(int,input().split()))
m=int(input())
b=list(map(int,input().split()))
print(*sorted(a+b))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int m;cin>>m;vector<int>b(m);for(auto&x:b)cin>>x;vector<int>c;merge(a.begin(),a.end(),b.begin(),b.end(),back_inserter(c));for(int i=0;i<c.size();i++){if(i)cout<<" ";cout<<c[i];}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]x=new int[n];for(int i=0;i<n;i++)x[i]=sc.nextInt();int m=sc.nextInt();int[]y=new int[m];for(int i=0;i<m;i++)y[i]=sc.nextInt();int[]z=new int[n+m];System.arraycopy(x,0,z,0,n);System.arraycopy(y,0,z,n,m);Arrays.sort(z);System.out.println(Arrays.stream(z).mapToObj(Integer::toString).reduce((p,q)->p+" "+q).get());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);const b=L[3].split('' '').map(Number);console.log([...a,...b].sort((x,y)=>x-y).join('' ''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 3 5
3
2 4 6','1 2 3 4 5 6',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
1 2
2
3 4','1 2 3 4',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 2 3
3
1 2 3','1 1 2 2 3 3',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Power of Two','Python',1,7,10,0,@baseOrder+30);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print YES if n is a power of 2, else NO.</p>','1 <= n <= 10^18','16','YES','n=int(input())
print(''YES'' if n>0 and (n&(n-1))==0 else ''NO'')','#include<bits/stdc++.h>
using namespace std;
int main(){long long n;cin>>n;cout<<((n>0&&(n&(n-1))==0)?"YES":"NO");}','import java.util.*;
public class Solution{public static void main(String[] a){long n=new Scanner(System.in).nextLong();System.out.println(n>0&&(n&(n-1))==0?"YES":"NO");}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=BigInt(l.trim());console.log(n>0n&&(n&(n-1n))===0n?''YES'':''NO'');rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'16','YES',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6','NO',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','YES',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1024','YES',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'String Compression','Python',1,7,10,0,@baseOrder+31);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Compress string using run-length encoding. e.g. aabccc → a2b1c3</p>','1 <= len(s) <= 1000','aabccc','a2b1c3','s=input().strip()
res=''''
i=0
while i<len(s):
    c=s[i];cnt=0
    while i<len(s) and s[i]==c:cnt+=1;i+=1
    res+=c+str(cnt)
print(res)','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;string res="";int i=0;while(i<s.size()){char c=s[i];int cnt=0;while(i<s.size()&&s[i]==c){cnt++;i++;}res+=c+to_string(cnt);}cout<<res;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();StringBuilder sb=new StringBuilder();int i=0;while(i<s.length()){char c=s.charAt(i);int cnt=0;while(i<s.length()&&s.charAt(i)==c){cnt++;i++;}sb.append(c).append(cnt);}System.out.println(sb);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const s=l.trim();let res='''',i=0;while(i<s.length){let c=s[i],cnt=0;while(i<s.length&&s[i]===c){cnt++;i++;}res+=c+cnt;}console.log(res);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'aabccc','a2b1c3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'abcd','a1b1c1d1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'aaabbb','a3b3',1,2);

-- ═══ .NET Full Stack — Coding Questions ═══
SET @tid = (SELECT Id FROM MockTests WHERE Title='.NET Full Stack Assessment' ORDER BY Id LIMIT 1);
SET @baseOrder = (SELECT COALESCE(MAX(DisplayOrder),17) FROM MockTestQuestions WHERE MockTestId=@tid);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Reverse a String','DotNet',1,7,10,0,@baseOrder+1);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given a string <code>s</code>, return its reverse.</p>','1 <= len(s) <= 1000','hello','olleh','s = input()
print(s[::-1])','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;reverse(s.begin(),s.end());cout<<s;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);String s=sc.next();System.out.println(new StringBuilder(s).reverse());}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log(l.trim().split('''').reverse().join(''''));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello','olleh',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'racecar','racecar',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'python','nohtyp',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'abcde','edcba',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Count Vowels','DotNet',1,7,10,0,@baseOrder+2);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Count the number of vowels (a,e,i,o,u) in a string (case-insensitive).</p>','1 <= len(s) <= 1000','Hello World','3','s=input().lower()
print(sum(1 for c in s if c in ''aeiou''))','#include<bits/stdc++.h>
using namespace std;
int main(){string s;getline(cin,s);int c=0;for(char x:s){x=tolower(x);if(string("aeiou").find(x)!=string::npos)c++;}cout<<c;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);String s=sc.nextLine().toLowerCase();long c=s.chars().filter(x->"aeiou".indexOf(x)>=0).count();System.out.println(c);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log([...l.toLowerCase()].filter(c=>''aeiou''.includes(c)).length);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Hello World','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Python','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'AEIOU','5',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'rhythm','0',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Fibonacci','DotNet',1,7,10,0,@baseOrder+3);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print the first <code>n</code> Fibonacci numbers, space-separated.</p>','1 <= n <= 30','7','0 1 1 2 3 5 8','n=int(input())
a,b=0,1
res=[]
for _ in range(n):
    res.append(a)
    a,b=b,a+b
print(*res)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;long long a=0,b=1;for(int i=0;i<n;i++){cout<<a;if(i<n-1)cout<<" ";long long c=a+b;a=b;b=c;}}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();long x=0,y=1;StringBuilder sb=new StringBuilder();for(int i=0;i<n;i++){if(i>0)sb.append(" ");sb.append(x);long z=x+y;x=y;y=z;}System.out.println(sb);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;let a=0,b=1,r=[];for(let i=0;i<n;i++){r.push(a);[a,b]=[b,a+b];}console.log(r.join('' ''));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'7','0 1 1 2 3 5 8',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','0',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'10','0 1 1 2 3 5 8 13 21 34',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5','0 1 1 2 3',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Palindrome Check','DotNet',1,7,10,0,@baseOrder+4);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print <code>YES</code> if string is palindrome else <code>NO</code>.</p>','1 <= len(s) <= 1000','racecar','YES','s=input().strip()
print(''YES'' if s==s[::-1] else ''NO'')','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;string r=s;reverse(r.begin(),r.end());cout<<(s==r?"YES":"NO");}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();System.out.println(s.equals(new StringBuilder(s).reverse().toString())?"YES":"NO");}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const s=l.trim();console.log(s===s.split('''').reverse().join('''')?''YES'':''NO'');rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'racecar','YES',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello','NO',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'madam','YES',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'level','YES',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Two Sum','DotNet',1,7,10,0,@baseOrder+5);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given array of integers and a target, print indices of two numbers that sum to target.</p><p>Line 1: n, Line 2: n numbers, Line 3: target</p>','2 <= n <= 10^4','4
2 7 11 15
9','0 1','n=int(input())
nums=list(map(int,input().split()))
t=int(input())
seen={}
for i,x in enumerate(nums):
    if t-x in seen:
        print(seen[t-x],i)
        break
    seen[x]=i','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int t;cin>>t;map<int,int>m;for(int i=0;i<n;i++){if(m.count(t-a[i])){cout<<m[t-a[i]]<<" "<<i;return 0;}m[a[i]]=i;}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();int t=sc.nextInt();Map<Integer,Integer>m=new HashMap<>();for(int i=0;i<n;i++){if(m.containsKey(t-arr[i])){System.out.println(m.get(t-arr[i])+" "+i);return;}m.put(arr[i],i);}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const nums=L[1].split('' '').map(Number);const t=+L[2];const m={};for(let i=0;i<nums.length;i++){if(m[t-nums[i]]!==undefined){console.log(m[t-nums[i]]+'' ''+i);return;}m[nums[i]]=i;}});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
2 7 11 15
9','0 1',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
3 2 4
6','1 2',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
3 3
6','0 1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'FizzBuzz','DotNet',1,7,10,0,@baseOrder+6);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>For 1 to n: print Fizz (div by 3), Buzz (div by 5), FizzBuzz (both), else number.</p>','1 <= n <= 1000','5','1
2
Fizz
4
Buzz','n=int(input())
for i in range(1,n+1):
    if i%15==0:print(''FizzBuzz'')
    elif i%3==0:print(''Fizz'')
    elif i%5==0:print(''Buzz'')
    else:print(i)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;for(int i=1;i<=n;i++){if(i%15==0)cout<<"FizzBuzz\n";else if(i%3==0)cout<<"Fizz\n";else if(i%5==0)cout<<"Buzz\n";else cout<<i<<"\n";}}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();for(int i=1;i<=n;i++){if(i%15==0)System.out.println("FizzBuzz");else if(i%3==0)System.out.println("Fizz");else if(i%5==0)System.out.println("Buzz");else System.out.println(i);}}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;for(let i=1;i<=n;i++){if(i%15===0)console.log(''FizzBuzz'');else if(i%3===0)console.log(''Fizz'');else if(i%5===0)console.log(''Buzz'');else console.log(i);}rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5','1
2
Fizz
4
Buzz',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'15','1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3','1
2
Fizz',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Max in Array','DotNet',1,7,10,0,@baseOrder+7);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find maximum value in an array. Line 1: n, Line 2: n integers.</p>','1 <= n <= 10^5','5
3 1 4 1 5','5','n=int(input())
print(max(map(int,input().split())))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;int mx=INT_MIN;for(int i=0;i<n;i++){int x;cin>>x;mx=max(mx,x);}cout<<mx;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int mx=Integer.MIN_VALUE;while(n-->0){int x=sc.nextInt();mx=Math.max(mx,x);}System.out.println(mx);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{console.log(Math.max(...L[1].split('' '').map(Number)));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
3 1 4 1 5','5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
-1 -5 -2','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
0 0 0 1','1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Sum of Digits','DotNet',1,7,10,0,@baseOrder+8);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given a non-negative integer, print the sum of its digits.</p>','0 <= n <= 10^18','1234','10','print(sum(int(c) for c in input().strip()))','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;int t=0;for(char c:s)t+=c-''0'';cout<<t;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();int t=0;for(char c:s.toCharArray())t+=c-''0'';System.out.println(t);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log([...l.trim()].reduce((s,c)=>s+parseInt(c),0));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1234','10',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'999','27',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'0','0',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'100','1',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Prime Check','DotNet',1,7,10,0,@baseOrder+9);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print <code>PRIME</code> or <code>NOT PRIME</code>.</p>','1 <= n <= 10^6','17','PRIME','n=int(input())
if n<2:print(''NOT PRIME'')
else:print(''PRIME'' if all(n%i!=0 for i in range(2,int(n**0.5)+1)) else ''NOT PRIME'')','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;if(n<2){cout<<"NOT PRIME";return 0;}for(int i=2;i*i<=n;i++)if(n%i==0){cout<<"NOT PRIME";return 0;}cout<<"PRIME";}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();if(n<2){System.out.println("NOT PRIME");return;}for(int i=2;i*i<=n;i++)if(n%i==0){System.out.println("NOT PRIME");return;}System.out.println("PRIME");}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;if(n<2){console.log(''NOT PRIME'');rl.close();return;}for(let i=2;i*i<=n;i++)if(n%i===0){console.log(''NOT PRIME'');rl.close();return;}console.log(''PRIME'');rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'17','PRIME',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4','NOT PRIME',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','NOT PRIME',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'97','PRIME',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Factorial','DotNet',1,7,10,0,@baseOrder+10);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print n! (n <= 15).</p>','0 <= n <= 15','5','120','import math
print(math.factorial(int(input())))','#include<bits/stdc++.h>
using namespace std;
int main(){long long n,f=1;cin>>n;for(long long i=1;i<=n;i++)f*=i;cout<<f;}','import java.util.*;
public class Solution{public static void main(String[] a){long n=new Scanner(System.in).nextLong();long f=1;for(long i=1;i<=n;i++)f*=i;System.out.println(f);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{let n=+l,f=1;for(let i=1;i<=n;i++)f*=i;console.log(f);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5','120',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'0','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'10','3628800',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'12','479001600',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Binary Search','DotNet',1,7,10,0,@baseOrder+11);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given sorted array and target, print index (0-based) or -1 if not found.</p><p>Line 1: n, Line 2: sorted integers, Line 3: target</p>','1 <= n <= 10^5','5
1 3 5 7 9
7','3','n=int(input())
arr=list(map(int,input().split()))
t=int(input())
l,r=0,n-1
while l<=r:
    m=(l+r)//2
    if arr[m]==t:print(m);exit()
    elif arr[m]<t:l=m+1
    else:r=m-1
print(-1)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int t;cin>>t;int l=0,r=n-1;while(l<=r){int m=(l+r)/2;if(a[m]==t){cout<<m;return 0;}else if(a[m]<t)l=m+1;else r=m-1;}cout<<-1;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();int t=sc.nextInt(),l=0,r=n-1;while(l<=r){int m=(l+r)/2;if(arr[m]==t){System.out.println(m);return;}else if(arr[m]<t)l=m+1;else r=m-1;}System.out.println(-1);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);const t=+L[2];let l=0,r=a.length-1;while(l<=r){const m=Math.floor((l+r)/2);if(a[m]===t){console.log(m);return;}else if(a[m]<t)l=m+1;else r=m-1;}console.log(-1);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
1 3 5 7 9
7','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 2 3
4','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6
2 4 6 8 10 12
10','4',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Word Count','DotNet',1,7,10,0,@baseOrder+12);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print the number of words in a sentence.</p>','1 <= len(s) <= 1000','Hello World how are you','5','print(len(input().split()))','#include<bits/stdc++.h>
using namespace std;
int main(){string line;getline(cin,line);istringstream iss(line);int c=0;string w;while(iss>>w)c++;cout<<c;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).nextLine().trim();System.out.println(s.isEmpty()?0:s.split("\\s+").length);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log(l.trim().split(/\s+/).filter(Boolean).length);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Hello World how are you','5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'one','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Python is awesome','3',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Anagram Check','DotNet',1,7,10,0,@baseOrder+13);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given two strings on separate lines, print YES if anagrams else NO (case-insensitive).</p>','1 <= len <= 1000','listen
silent','YES','a,b=input().lower(),input().lower()
print(''YES'' if sorted(a)==sorted(b) else ''NO'')','#include<bits/stdc++.h>
using namespace std;
int main(){string a,b;cin>>a>>b;for(auto&c:a)c=tolower(c);for(auto&c:b)c=tolower(c);sort(a.begin(),a.end());sort(b.begin(),b.end());cout<<(a==b?"YES":"NO");}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);char[]x=sc.next().toLowerCase().toCharArray();char[]y=sc.next().toLowerCase().toCharArray();Arrays.sort(x);Arrays.sort(y);System.out.println(Arrays.equals(x,y)?"YES":"NO");}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim().toLowerCase()));rl.on(''close'',()=>{console.log([...L[0]].sort().join('''')===[...L[1]].sort().join('''')?''YES'':''NO'');});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'listen
silent','YES',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello
world','NO',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'triangle
integral','YES',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Largest Palindrome Substring Length','DotNet',1,7,10,0,@baseOrder+14);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find the length of the longest palindromic substring.</p>','1 <= len(s) <= 1000','babad','3','s=input().strip()
n=len(s)
best=1
for i in range(n):
    for r in range(2):
        l,ri=i,i+r
        while l>=0 and ri<n and s[l]==s[ri]:
            best=max(best,ri-l+1)
            l-=1;ri+=1
print(best)','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;int n=s.size(),best=1;for(int i=0;i<n;i++)for(int r=0;r<2;r++){int l=i,ri=i+r;while(l>=0&&ri<n&&s[l]==s[ri]){best=max(best,ri-l+1);l--;ri++;}}cout<<best;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();int n=s.length(),best=1;for(int i=0;i<n;i++)for(int r=0;r<2;r++){int l=i,ri=i+r;while(l>=0&&ri<n&&s.charAt(l)==s.charAt(ri)){best=Math.max(best,ri-l+1);l--;ri++;}}System.out.println(best);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const s=l.trim();let best=1;for(let i=0;i<s.length;i++)for(let r=0;r<2;r++){let[L,ri]=[i,i+r];while(L>=0&&ri<s.length&&s[L]===s[ri]){best=Math.max(best,ri-L+1);L--;ri++;}}console.log(best);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'babad','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'cbbd','2',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'racecar','7',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Sum of Array','DotNet',1,7,10,0,@baseOrder+15);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print sum of n integers. Line 1: n, Line 2: n numbers.</p>','1 <= n <= 10^5','5
1 2 3 4 5','15','n=int(input())
print(sum(map(int,input().split())))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;long long s=0;for(int i=0;i<n;i++){int x;cin>>x;s+=x;}cout<<s;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();long s=0;while(n-->0)s+=sc.nextLong();System.out.println(s);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{console.log(L[1].split('' '').reduce((a,b)=>a+ +b,0));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
1 2 3 4 5','15',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
-1 0 1','0',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1
100','100',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Count Words Starting With Vowel','DotNet',1,7,10,0,@baseOrder+16);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Count words in sentence that start with a vowel (case-insensitive).</p>','1 <= len(s) <= 1000','apple is an orange','3','s=input().lower()
print(sum(1 for w in s.split() if w[0] in ''aeiou''))','#include<bits/stdc++.h>
using namespace std;
int main(){string line;getline(cin,line);istringstream iss(line);string w;int c=0;while(iss>>w){char ch=tolower(w[0]);if(string("aeiou").find(ch)!=string::npos)c++;}cout<<c;}','import java.util.*;
public class Solution{public static void main(String[] a){String[]ws=new Scanner(System.in).nextLine().toLowerCase().split("\\s+");long c=Arrays.stream(ws).filter(w->"aeiou".indexOf(w.charAt(0))>=0).count();System.out.println(c);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log(l.toLowerCase().split(/\s+/).filter(w=>''aeiou''.includes(w[0])).length);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'apple is an orange','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello world','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Every Algorithm Is Optimal','4',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'GCD of Two Numbers','DotNet',1,7,10,0,@baseOrder+17);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print GCD of two space-separated integers.</p>','1 <= a,b <= 10^9','12 8','4','a,b=map(int,input().split())
from math import gcd
print(gcd(a,b))','#include<bits/stdc++.h>
using namespace std;
int main(){long long a,b;cin>>a>>b;cout<<__gcd(a,b);}','import java.util.*;
public class Solution{static long gcd(long a,long b){return b==0?a:gcd(b,a%b);}public static void main(String[] a){Scanner sc=new Scanner(System.in);System.out.println(gcd(sc.nextLong(),sc.nextLong()));}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const[a,b]=l.split('' '').map(Number);const g=(x,y)=>y===0?x:g(y,x%y);console.log(g(a,b));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'12 8','4',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'100 75','25',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'17 13','1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Second Largest','DotNet',1,7,10,0,@baseOrder+18);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find the second largest unique element. Print -1 if none.</p><p>Line 1: n, Line 2: n integers.</p>','2 <= n <= 10^5','5
3 1 4 1 5','4','n=int(input())
nums=list(map(int,input().split()))
uniq=sorted(set(nums))
print(uniq[-2] if len(uniq)>=2 else -1)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;set<int>s;for(int i=0;i<n;i++){int x;cin>>x;s.insert(x);}auto it=s.end();--it;if(it==s.begin())cout<<-1;else{--it;cout<<*it;}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();TreeSet<Integer>s=new TreeSet<>();while(n-->0)s.add(sc.nextInt());if(s.size()<2)System.out.println(-1);else{s.pollLast();System.out.println(s.last());}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const s=[...new Set(L[1].split('' '').map(Number))].sort((a,b)=>a-b);console.log(s.length>=2?s[s.length-2]:-1);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
3 1 4 1 5','4',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
5 5 5','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
10 20 30 40','30',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Remove Duplicates','DotNet',1,7,10,0,@baseOrder+19);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print unique elements in original order, space-separated.</p><p>Line 1: n, Line 2: n integers.</p>','1 <= n <= 10^5','6
1 2 2 3 1 4','1 2 3 4','n=int(input())
nums=list(map(int,input().split()))
seen=set()
res=[]
for x in nums:
    if x not in seen:
        res.append(x)
        seen.add(x)
print(*res)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;set<int>seen;bool first=true;for(int x:a){if(!seen.count(x)){if(!first)cout<<" ";cout<<x;first=false;seen.insert(x);}}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();LinkedHashSet<Integer>s=new LinkedHashSet<>();while(n-->0)s.add(sc.nextInt());System.out.println(s.toString().replaceAll("[\\[\\],]","").trim());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const seen=new Set();console.log(L[1].split('' '').map(Number).filter(x=>!seen.has(x)&&seen.add(x)).join('' ''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6
1 2 2 3 1 4','1 2 3 4',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
5 5 5','5',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
3 1 4 1 5','3 1 4 5',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Longest Common Prefix','DotNet',1,7,10,0,@baseOrder+20);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find longest common prefix of n strings.</p><p>Line 1: n, then n strings.</p>','1 <= n <= 100','3
flower
flow
flight','fl','n=int(input())
words=[input() for _ in range(n)]
p=words[0]
for w in words[1:]:
    while not w.startswith(p):p=p[:-1]
print(p)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<string>v(n);for(auto&s:v)cin>>s;string p=v[0];for(int i=1;i<n;i++){while(v[i].find(p)!=0){p=p.substr(0,p.size()-1);if(p.empty()){cout<<"";return 0;}}}cout<<p;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();String[]w=new String[n];for(int i=0;i<n;i++)w[i]=sc.next();String p=w[0];for(int i=1;i<n;i++){while(!w[i].startsWith(p)){p=p.substring(0,p.length()-1);if(p.isEmpty()){System.out.println("");return;}}}System.out.println(p);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const n=+L[0];const words=L.slice(1,n+1);let p=words[0];for(let i=1;i<words.length;i++){while(!words[i].startsWith(p)){p=p.slice(0,-1);if(!p){console.log('''');return;}}}console.log(p);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
flower
flow
flight','fl',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
dog
racecar','',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1
hello','hello',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Count Occurrences','DotNet',1,7,10,0,@baseOrder+21);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Count how many times a character appears in string (case-sensitive).</p><p>Line 1: string, Line 2: character</p>','1 <= len(s) <= 1000','hello
l','2','s=input()
c=input()
print(s.count(c))','#include<bits/stdc++.h>
using namespace std;
int main(){string s,c;getline(cin,s);getline(cin,c);cout<<count(s.begin(),s.end(),c[0]);}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);String s=sc.nextLine();char c=sc.nextLine().charAt(0);System.out.println(s.chars().filter(x->x==c).count());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l));rl.on(''close'',()=>{const[s,c]=L;console.log([...s].filter(x=>x===c[0]).length);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello
l','2',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'programming
g','2',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'aaaaaa
a','6',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Matrix Diagonal Sum','DotNet',1,7,10,0,@baseOrder+22);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print sum of main diagonal elements of n×n matrix.</p><p>Line 1: n, then n lines of n integers.</p>','1 <= n <= 100','3
1 2 3
4 5 6
7 8 9','15','n=int(input())
m=[list(map(int,input().split())) for _ in range(n)]
print(sum(m[i][i] for i in range(n)))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<vector<int>>m(n,vector<int>(n));for(auto&r:m)for(auto&x:r)cin>>x;long long s=0;for(int i=0;i<n;i++)s+=m[i][i];cout<<s;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();long s=0;for(int i=0;i<n;i++){for(int j=0;j<n;j++){int x=sc.nextInt();if(i==j)s+=x;}}System.out.println(s);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const n=+L[0];let s=0;for(let i=0;i<n;i++){const r=L[i+1].split('' '').map(Number);s+=r[i];}console.log(s);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 2 3
4 5 6
7 8 9','15',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
1 2
3 4','5',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
1 0 0 0
0 2 0 0
0 0 3 0
0 0 0 4','10',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Bubble Sort','DotNet',1,7,10,0,@baseOrder+23);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Sort n integers using Bubble Sort, print sorted array space-separated.</p>','1 <= n <= 1000','5
5 3 1 4 2','1 2 3 4 5','n=int(input())
a=list(map(int,input().split()))
for i in range(n):
    for j in range(n-i-1):
        if a[j]>a[j+1]:a[j],a[j+1]=a[j+1],a[j]
print(*a)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;for(int i=0;i<n;i++)for(int j=0;j<n-i-1;j++)if(a[j]>a[j+1])swap(a[j],a[j+1]);for(int i=0;i<n;i++){if(i)cout<<" ";cout<<a[i];}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();for(int i=0;i<n;i++)for(int j=0;j<n-i-1;j++)if(arr[j]>arr[j+1]){int t=arr[j];arr[j]=arr[j+1];arr[j+1]=t;}System.out.println(Arrays.stream(arr).mapToObj(Integer::toString).reduce((x,y)->x+" "+y).get());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);for(let i=0;i<a.length;i++)for(let j=0;j<a.length-i-1;j++)if(a[j]>a[j+1])[a[j],a[j+1]]=[a[j+1],a[j]];console.log(a.join('' ''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
5 3 1 4 2','1 2 3 4 5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
3 1 2','1 2 3',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
4 3 2 1','1 2 3 4',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Stack using List','DotNet',1,7,10,0,@baseOrder+24);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Simulate a stack. Line 1: q queries. Each query: PUSH x or POP (print popped, or -1 if empty).</p>','1 <= q <= 1000','4
PUSH 5
PUSH 3
POP
POP','3
5','q=int(input())
stack=[]
for _ in range(q):
    line=input().split()
    if line[0]==''PUSH'':stack.append(int(line[1]))
    else:print(stack.pop() if stack else -1)','#include<bits/stdc++.h>
using namespace std;
int main(){int q;cin>>q;cin.ignore();stack<int>st;while(q--){string line;getline(cin,line);if(line[0]==''P''&&line[1]==''U''){st.push(stoi(line.substr(5)));}else{if(st.empty())cout<<-1<<"\n";else{cout<<st.top()<<"\n";st.pop();}}}}
','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int q=sc.nextInt();sc.nextLine();Deque<Integer>stack=new ArrayDeque<>();while(q-->0){String[]l=sc.nextLine().split(" ");if(l[0].equals("PUSH"))stack.push(Integer.parseInt(l[1]));else System.out.println(stack.isEmpty()?-1:stack.pop());}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const stack=[];const out=[];for(let i=1;i<L.length;i++){const p=L[i].split('' '');if(p[0]===''PUSH'')stack.push(+p[1]);else out.push(stack.length?stack.pop():-1);}console.log(out.join(''\n''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
PUSH 5
PUSH 3
POP
POP','3
5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
POP
PUSH 1','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
PUSH 10
PUSH 20
POP','20',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Pattern - Right Triangle','DotNet',1,7,10,0,@baseOrder+25);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print a right triangle of stars of height n.</p>','1 <= n <= 20','4','*
**
***
****','n=int(input())
for i in range(1,n+1):print(''*''*i)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;for(int i=1;i<=n;i++){for(int j=0;j<i;j++)cout<<''*'';cout<<"\n";}}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();for(int i=1;i<=n;i++){System.out.println("*".repeat(i));}}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;for(let i=1;i<=n;i++)console.log(''*''.repeat(i));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4','*
**
***
****',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','*',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3','*
**
***',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Kadane''s Algorithm','DotNet',1,7,10,0,@baseOrder+26);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find maximum subarray sum.</p><p>Line 1: n, Line 2: n integers.</p>','1 <= n <= 10^5','6
-2 1 -3 4 -1 2','5','n=int(input())
a=list(map(int,input().split()))
cur=best=a[0]
for x in a[1:]:
    cur=max(x,cur+x)
    best=max(best,cur)
print(best)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int cur=a[0],best=a[0];for(int i=1;i<n;i++){cur=max(a[i],cur+a[i]);best=max(best,cur);}cout<<best;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();int cur=arr[0],best=arr[0];for(int i=1;i<n;i++){cur=Math.max(arr[i],cur+arr[i]);best=Math.max(best,cur);}System.out.println(best);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);let cur=a[0],best=a[0];for(let i=1;i<a.length;i++){cur=Math.max(a[i],cur+a[i]);best=Math.max(best,cur);}console.log(best);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6
-2 1 -3 4 -1 2','5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
1 2 3 4','10',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
-1 -2 -3','-1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Even or Odd Batch','DotNet',1,7,10,0,@baseOrder+27);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Line 1: n. For each of next n lines, print EVEN or ODD.</p>','1 <= n <= 100','3
2
7
10','EVEN
ODD
EVEN','n=int(input())
for _ in range(n):
    x=int(input())
    print(''EVEN'' if x%2==0 else ''ODD'')','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;while(n--){int x;cin>>x;cout<<(x%2==0?"EVEN":"ODD")<<"\n";}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();while(n-->0){int x=sc.nextInt();System.out.println(x%2==0?"EVEN":"ODD");}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const n=+L[0];for(let i=1;i<=n;i++)console.log(+L[i]%2===0?''EVEN'':''ODD'');});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
2
7
10','EVEN
ODD
EVEN',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1
0','EVEN',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
-3
4','ODD
EVEN',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Roman to Integer','DotNet',1,7,10,0,@baseOrder+28);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Convert Roman numeral string to integer.</p>','1 <= len(s) <= 15, valid Roman','XIV','14','s=input().strip()
v={''I'':1,''V'':5,''X'':10,''L'':50,''C'':100,''D'':500,''M'':1000}
res=0
for i in range(len(s)):
    if i+1<len(s) and v[s[i]]<v[s[i+1]]:res-=v[s[i]]
    else:res+=v[s[i]]
print(res)','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;map<char,int>v={{''I'',1},{''V'',5},{''X'',10},{''L'',50},{''C'',100},{''D'',500},{''M'',1000}};int res=0;for(int i=0;i<s.size();i++){if(i+1<s.size()&&v[s[i]]<v[s[i+1]])res-=v[s[i]];else res+=v[s[i]];}cout<<res;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();Map<Character,Integer>v=new HashMap<>();v.put(''I'',1);v.put(''V'',5);v.put(''X'',10);v.put(''L'',50);v.put(''C'',100);v.put(''D'',500);v.put(''M'',1000);int res=0;for(int i=0;i<s.length();i++){if(i+1<s.length()&&v.get(s.charAt(i))<v.get(s.charAt(i+1)))res-=v.get(s.charAt(i));else res+=v.get(s.charAt(i));}System.out.println(res);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const v={I:1,V:5,X:10,L:50,C:100,D:500,M:1000};let res=0;for(let i=0;i<l.length;i++){if(i+1<l.length&&v[l[i]]<v[l[i+1]])res-=v[l[i]];else res+=v[l[i]];}console.log(res);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'XIV','14',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'IX','9',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'MCMXCIV','1994',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Merge Sorted Arrays','DotNet',1,7,10,0,@baseOrder+29);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Merge two sorted arrays into one sorted array.</p><p>Line 1: n, Line 2: n numbers, Line 3: m, Line 4: m numbers</p>','1 <= n,m <= 10^5','3
1 3 5
3
2 4 6','1 2 3 4 5 6','n=int(input())
a=list(map(int,input().split()))
m=int(input())
b=list(map(int,input().split()))
print(*sorted(a+b))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int m;cin>>m;vector<int>b(m);for(auto&x:b)cin>>x;vector<int>c;merge(a.begin(),a.end(),b.begin(),b.end(),back_inserter(c));for(int i=0;i<c.size();i++){if(i)cout<<" ";cout<<c[i];}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]x=new int[n];for(int i=0;i<n;i++)x[i]=sc.nextInt();int m=sc.nextInt();int[]y=new int[m];for(int i=0;i<m;i++)y[i]=sc.nextInt();int[]z=new int[n+m];System.arraycopy(x,0,z,0,n);System.arraycopy(y,0,z,n,m);Arrays.sort(z);System.out.println(Arrays.stream(z).mapToObj(Integer::toString).reduce((p,q)->p+" "+q).get());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);const b=L[3].split('' '').map(Number);console.log([...a,...b].sort((x,y)=>x-y).join('' ''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 3 5
3
2 4 6','1 2 3 4 5 6',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
1 2
2
3 4','1 2 3 4',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 2 3
3
1 2 3','1 1 2 2 3 3',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Power of Two','DotNet',1,7,10,0,@baseOrder+30);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print YES if n is a power of 2, else NO.</p>','1 <= n <= 10^18','16','YES','n=int(input())
print(''YES'' if n>0 and (n&(n-1))==0 else ''NO'')','#include<bits/stdc++.h>
using namespace std;
int main(){long long n;cin>>n;cout<<((n>0&&(n&(n-1))==0)?"YES":"NO");}','import java.util.*;
public class Solution{public static void main(String[] a){long n=new Scanner(System.in).nextLong();System.out.println(n>0&&(n&(n-1))==0?"YES":"NO");}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=BigInt(l.trim());console.log(n>0n&&(n&(n-1n))===0n?''YES'':''NO'');rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'16','YES',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6','NO',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','YES',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1024','YES',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'String Compression','DotNet',1,7,10,0,@baseOrder+31);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Compress string using run-length encoding. e.g. aabccc → a2b1c3</p>','1 <= len(s) <= 1000','aabccc','a2b1c3','s=input().strip()
res=''''
i=0
while i<len(s):
    c=s[i];cnt=0
    while i<len(s) and s[i]==c:cnt+=1;i+=1
    res+=c+str(cnt)
print(res)','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;string res="";int i=0;while(i<s.size()){char c=s[i];int cnt=0;while(i<s.size()&&s[i]==c){cnt++;i++;}res+=c+to_string(cnt);}cout<<res;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();StringBuilder sb=new StringBuilder();int i=0;while(i<s.length()){char c=s.charAt(i);int cnt=0;while(i<s.length()&&s.charAt(i)==c){cnt++;i++;}sb.append(c).append(cnt);}System.out.println(sb);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const s=l.trim();let res='''',i=0;while(i<s.length){let c=s[i],cnt=0;while(i<s.length&&s[i]===c){cnt++;i++;}res+=c+cnt;}console.log(res);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'aabccc','a2b1c3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'abcd','a1b1c1d1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'aaabbb','a3b3',1,2);

-- ═══ Java Full Stack — Coding Questions ═══
SET @tid = (SELECT Id FROM MockTests WHERE Title='Java Full Stack Assessment' ORDER BY Id LIMIT 1);
SET @baseOrder = (SELECT COALESCE(MAX(DisplayOrder),17) FROM MockTestQuestions WHERE MockTestId=@tid);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Reverse a String','Java',1,7,10,0,@baseOrder+1);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given a string <code>s</code>, return its reverse.</p>','1 <= len(s) <= 1000','hello','olleh','s = input()
print(s[::-1])','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;reverse(s.begin(),s.end());cout<<s;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);String s=sc.next();System.out.println(new StringBuilder(s).reverse());}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log(l.trim().split('''').reverse().join(''''));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello','olleh',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'racecar','racecar',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'python','nohtyp',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'abcde','edcba',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Count Vowels','Java',1,7,10,0,@baseOrder+2);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Count the number of vowels (a,e,i,o,u) in a string (case-insensitive).</p>','1 <= len(s) <= 1000','Hello World','3','s=input().lower()
print(sum(1 for c in s if c in ''aeiou''))','#include<bits/stdc++.h>
using namespace std;
int main(){string s;getline(cin,s);int c=0;for(char x:s){x=tolower(x);if(string("aeiou").find(x)!=string::npos)c++;}cout<<c;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);String s=sc.nextLine().toLowerCase();long c=s.chars().filter(x->"aeiou".indexOf(x)>=0).count();System.out.println(c);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log([...l.toLowerCase()].filter(c=>''aeiou''.includes(c)).length);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Hello World','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Python','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'AEIOU','5',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'rhythm','0',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Fibonacci','Java',1,7,10,0,@baseOrder+3);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print the first <code>n</code> Fibonacci numbers, space-separated.</p>','1 <= n <= 30','7','0 1 1 2 3 5 8','n=int(input())
a,b=0,1
res=[]
for _ in range(n):
    res.append(a)
    a,b=b,a+b
print(*res)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;long long a=0,b=1;for(int i=0;i<n;i++){cout<<a;if(i<n-1)cout<<" ";long long c=a+b;a=b;b=c;}}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();long x=0,y=1;StringBuilder sb=new StringBuilder();for(int i=0;i<n;i++){if(i>0)sb.append(" ");sb.append(x);long z=x+y;x=y;y=z;}System.out.println(sb);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;let a=0,b=1,r=[];for(let i=0;i<n;i++){r.push(a);[a,b]=[b,a+b];}console.log(r.join('' ''));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'7','0 1 1 2 3 5 8',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','0',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'10','0 1 1 2 3 5 8 13 21 34',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5','0 1 1 2 3',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Palindrome Check','Java',1,7,10,0,@baseOrder+4);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print <code>YES</code> if string is palindrome else <code>NO</code>.</p>','1 <= len(s) <= 1000','racecar','YES','s=input().strip()
print(''YES'' if s==s[::-1] else ''NO'')','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;string r=s;reverse(r.begin(),r.end());cout<<(s==r?"YES":"NO");}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();System.out.println(s.equals(new StringBuilder(s).reverse().toString())?"YES":"NO");}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const s=l.trim();console.log(s===s.split('''').reverse().join('''')?''YES'':''NO'');rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'racecar','YES',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello','NO',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'madam','YES',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'level','YES',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Two Sum','Java',1,7,10,0,@baseOrder+5);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given array of integers and a target, print indices of two numbers that sum to target.</p><p>Line 1: n, Line 2: n numbers, Line 3: target</p>','2 <= n <= 10^4','4
2 7 11 15
9','0 1','n=int(input())
nums=list(map(int,input().split()))
t=int(input())
seen={}
for i,x in enumerate(nums):
    if t-x in seen:
        print(seen[t-x],i)
        break
    seen[x]=i','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int t;cin>>t;map<int,int>m;for(int i=0;i<n;i++){if(m.count(t-a[i])){cout<<m[t-a[i]]<<" "<<i;return 0;}m[a[i]]=i;}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();int t=sc.nextInt();Map<Integer,Integer>m=new HashMap<>();for(int i=0;i<n;i++){if(m.containsKey(t-arr[i])){System.out.println(m.get(t-arr[i])+" "+i);return;}m.put(arr[i],i);}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const nums=L[1].split('' '').map(Number);const t=+L[2];const m={};for(let i=0;i<nums.length;i++){if(m[t-nums[i]]!==undefined){console.log(m[t-nums[i]]+'' ''+i);return;}m[nums[i]]=i;}});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
2 7 11 15
9','0 1',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
3 2 4
6','1 2',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
3 3
6','0 1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'FizzBuzz','Java',1,7,10,0,@baseOrder+6);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>For 1 to n: print Fizz (div by 3), Buzz (div by 5), FizzBuzz (both), else number.</p>','1 <= n <= 1000','5','1
2
Fizz
4
Buzz','n=int(input())
for i in range(1,n+1):
    if i%15==0:print(''FizzBuzz'')
    elif i%3==0:print(''Fizz'')
    elif i%5==0:print(''Buzz'')
    else:print(i)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;for(int i=1;i<=n;i++){if(i%15==0)cout<<"FizzBuzz\n";else if(i%3==0)cout<<"Fizz\n";else if(i%5==0)cout<<"Buzz\n";else cout<<i<<"\n";}}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();for(int i=1;i<=n;i++){if(i%15==0)System.out.println("FizzBuzz");else if(i%3==0)System.out.println("Fizz");else if(i%5==0)System.out.println("Buzz");else System.out.println(i);}}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;for(let i=1;i<=n;i++){if(i%15===0)console.log(''FizzBuzz'');else if(i%3===0)console.log(''Fizz'');else if(i%5===0)console.log(''Buzz'');else console.log(i);}rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5','1
2
Fizz
4
Buzz',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'15','1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3','1
2
Fizz',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Max in Array','Java',1,7,10,0,@baseOrder+7);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find maximum value in an array. Line 1: n, Line 2: n integers.</p>','1 <= n <= 10^5','5
3 1 4 1 5','5','n=int(input())
print(max(map(int,input().split())))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;int mx=INT_MIN;for(int i=0;i<n;i++){int x;cin>>x;mx=max(mx,x);}cout<<mx;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int mx=Integer.MIN_VALUE;while(n-->0){int x=sc.nextInt();mx=Math.max(mx,x);}System.out.println(mx);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{console.log(Math.max(...L[1].split('' '').map(Number)));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
3 1 4 1 5','5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
-1 -5 -2','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
0 0 0 1','1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Sum of Digits','Java',1,7,10,0,@baseOrder+8);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given a non-negative integer, print the sum of its digits.</p>','0 <= n <= 10^18','1234','10','print(sum(int(c) for c in input().strip()))','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;int t=0;for(char c:s)t+=c-''0'';cout<<t;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();int t=0;for(char c:s.toCharArray())t+=c-''0'';System.out.println(t);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log([...l.trim()].reduce((s,c)=>s+parseInt(c),0));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1234','10',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'999','27',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'0','0',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'100','1',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Prime Check','Java',1,7,10,0,@baseOrder+9);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print <code>PRIME</code> or <code>NOT PRIME</code>.</p>','1 <= n <= 10^6','17','PRIME','n=int(input())
if n<2:print(''NOT PRIME'')
else:print(''PRIME'' if all(n%i!=0 for i in range(2,int(n**0.5)+1)) else ''NOT PRIME'')','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;if(n<2){cout<<"NOT PRIME";return 0;}for(int i=2;i*i<=n;i++)if(n%i==0){cout<<"NOT PRIME";return 0;}cout<<"PRIME";}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();if(n<2){System.out.println("NOT PRIME");return;}for(int i=2;i*i<=n;i++)if(n%i==0){System.out.println("NOT PRIME");return;}System.out.println("PRIME");}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;if(n<2){console.log(''NOT PRIME'');rl.close();return;}for(let i=2;i*i<=n;i++)if(n%i===0){console.log(''NOT PRIME'');rl.close();return;}console.log(''PRIME'');rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'17','PRIME',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4','NOT PRIME',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','NOT PRIME',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'97','PRIME',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Factorial','Java',1,7,10,0,@baseOrder+10);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print n! (n <= 15).</p>','0 <= n <= 15','5','120','import math
print(math.factorial(int(input())))','#include<bits/stdc++.h>
using namespace std;
int main(){long long n,f=1;cin>>n;for(long long i=1;i<=n;i++)f*=i;cout<<f;}','import java.util.*;
public class Solution{public static void main(String[] a){long n=new Scanner(System.in).nextLong();long f=1;for(long i=1;i<=n;i++)f*=i;System.out.println(f);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{let n=+l,f=1;for(let i=1;i<=n;i++)f*=i;console.log(f);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5','120',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'0','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'10','3628800',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'12','479001600',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Binary Search','Java',1,7,10,0,@baseOrder+11);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given sorted array and target, print index (0-based) or -1 if not found.</p><p>Line 1: n, Line 2: sorted integers, Line 3: target</p>','1 <= n <= 10^5','5
1 3 5 7 9
7','3','n=int(input())
arr=list(map(int,input().split()))
t=int(input())
l,r=0,n-1
while l<=r:
    m=(l+r)//2
    if arr[m]==t:print(m);exit()
    elif arr[m]<t:l=m+1
    else:r=m-1
print(-1)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int t;cin>>t;int l=0,r=n-1;while(l<=r){int m=(l+r)/2;if(a[m]==t){cout<<m;return 0;}else if(a[m]<t)l=m+1;else r=m-1;}cout<<-1;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();int t=sc.nextInt(),l=0,r=n-1;while(l<=r){int m=(l+r)/2;if(arr[m]==t){System.out.println(m);return;}else if(arr[m]<t)l=m+1;else r=m-1;}System.out.println(-1);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);const t=+L[2];let l=0,r=a.length-1;while(l<=r){const m=Math.floor((l+r)/2);if(a[m]===t){console.log(m);return;}else if(a[m]<t)l=m+1;else r=m-1;}console.log(-1);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
1 3 5 7 9
7','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 2 3
4','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6
2 4 6 8 10 12
10','4',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Word Count','Java',1,7,10,0,@baseOrder+12);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print the number of words in a sentence.</p>','1 <= len(s) <= 1000','Hello World how are you','5','print(len(input().split()))','#include<bits/stdc++.h>
using namespace std;
int main(){string line;getline(cin,line);istringstream iss(line);int c=0;string w;while(iss>>w)c++;cout<<c;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).nextLine().trim();System.out.println(s.isEmpty()?0:s.split("\\s+").length);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log(l.trim().split(/\s+/).filter(Boolean).length);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Hello World how are you','5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'one','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Python is awesome','3',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Anagram Check','Java',1,7,10,0,@baseOrder+13);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given two strings on separate lines, print YES if anagrams else NO (case-insensitive).</p>','1 <= len <= 1000','listen
silent','YES','a,b=input().lower(),input().lower()
print(''YES'' if sorted(a)==sorted(b) else ''NO'')','#include<bits/stdc++.h>
using namespace std;
int main(){string a,b;cin>>a>>b;for(auto&c:a)c=tolower(c);for(auto&c:b)c=tolower(c);sort(a.begin(),a.end());sort(b.begin(),b.end());cout<<(a==b?"YES":"NO");}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);char[]x=sc.next().toLowerCase().toCharArray();char[]y=sc.next().toLowerCase().toCharArray();Arrays.sort(x);Arrays.sort(y);System.out.println(Arrays.equals(x,y)?"YES":"NO");}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim().toLowerCase()));rl.on(''close'',()=>{console.log([...L[0]].sort().join('''')===[...L[1]].sort().join('''')?''YES'':''NO'');});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'listen
silent','YES',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello
world','NO',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'triangle
integral','YES',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Largest Palindrome Substring Length','Java',1,7,10,0,@baseOrder+14);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find the length of the longest palindromic substring.</p>','1 <= len(s) <= 1000','babad','3','s=input().strip()
n=len(s)
best=1
for i in range(n):
    for r in range(2):
        l,ri=i,i+r
        while l>=0 and ri<n and s[l]==s[ri]:
            best=max(best,ri-l+1)
            l-=1;ri+=1
print(best)','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;int n=s.size(),best=1;for(int i=0;i<n;i++)for(int r=0;r<2;r++){int l=i,ri=i+r;while(l>=0&&ri<n&&s[l]==s[ri]){best=max(best,ri-l+1);l--;ri++;}}cout<<best;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();int n=s.length(),best=1;for(int i=0;i<n;i++)for(int r=0;r<2;r++){int l=i,ri=i+r;while(l>=0&&ri<n&&s.charAt(l)==s.charAt(ri)){best=Math.max(best,ri-l+1);l--;ri++;}}System.out.println(best);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const s=l.trim();let best=1;for(let i=0;i<s.length;i++)for(let r=0;r<2;r++){let[L,ri]=[i,i+r];while(L>=0&&ri<s.length&&s[L]===s[ri]){best=Math.max(best,ri-L+1);L--;ri++;}}console.log(best);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'babad','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'cbbd','2',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'racecar','7',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Sum of Array','Java',1,7,10,0,@baseOrder+15);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print sum of n integers. Line 1: n, Line 2: n numbers.</p>','1 <= n <= 10^5','5
1 2 3 4 5','15','n=int(input())
print(sum(map(int,input().split())))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;long long s=0;for(int i=0;i<n;i++){int x;cin>>x;s+=x;}cout<<s;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();long s=0;while(n-->0)s+=sc.nextLong();System.out.println(s);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{console.log(L[1].split('' '').reduce((a,b)=>a+ +b,0));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
1 2 3 4 5','15',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
-1 0 1','0',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1
100','100',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Count Words Starting With Vowel','Java',1,7,10,0,@baseOrder+16);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Count words in sentence that start with a vowel (case-insensitive).</p>','1 <= len(s) <= 1000','apple is an orange','3','s=input().lower()
print(sum(1 for w in s.split() if w[0] in ''aeiou''))','#include<bits/stdc++.h>
using namespace std;
int main(){string line;getline(cin,line);istringstream iss(line);string w;int c=0;while(iss>>w){char ch=tolower(w[0]);if(string("aeiou").find(ch)!=string::npos)c++;}cout<<c;}','import java.util.*;
public class Solution{public static void main(String[] a){String[]ws=new Scanner(System.in).nextLine().toLowerCase().split("\\s+");long c=Arrays.stream(ws).filter(w->"aeiou".indexOf(w.charAt(0))>=0).count();System.out.println(c);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log(l.toLowerCase().split(/\s+/).filter(w=>''aeiou''.includes(w[0])).length);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'apple is an orange','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello world','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Every Algorithm Is Optimal','4',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'GCD of Two Numbers','Java',1,7,10,0,@baseOrder+17);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print GCD of two space-separated integers.</p>','1 <= a,b <= 10^9','12 8','4','a,b=map(int,input().split())
from math import gcd
print(gcd(a,b))','#include<bits/stdc++.h>
using namespace std;
int main(){long long a,b;cin>>a>>b;cout<<__gcd(a,b);}','import java.util.*;
public class Solution{static long gcd(long a,long b){return b==0?a:gcd(b,a%b);}public static void main(String[] a){Scanner sc=new Scanner(System.in);System.out.println(gcd(sc.nextLong(),sc.nextLong()));}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const[a,b]=l.split('' '').map(Number);const g=(x,y)=>y===0?x:g(y,x%y);console.log(g(a,b));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'12 8','4',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'100 75','25',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'17 13','1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Second Largest','Java',1,7,10,0,@baseOrder+18);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find the second largest unique element. Print -1 if none.</p><p>Line 1: n, Line 2: n integers.</p>','2 <= n <= 10^5','5
3 1 4 1 5','4','n=int(input())
nums=list(map(int,input().split()))
uniq=sorted(set(nums))
print(uniq[-2] if len(uniq)>=2 else -1)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;set<int>s;for(int i=0;i<n;i++){int x;cin>>x;s.insert(x);}auto it=s.end();--it;if(it==s.begin())cout<<-1;else{--it;cout<<*it;}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();TreeSet<Integer>s=new TreeSet<>();while(n-->0)s.add(sc.nextInt());if(s.size()<2)System.out.println(-1);else{s.pollLast();System.out.println(s.last());}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const s=[...new Set(L[1].split('' '').map(Number))].sort((a,b)=>a-b);console.log(s.length>=2?s[s.length-2]:-1);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
3 1 4 1 5','4',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
5 5 5','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
10 20 30 40','30',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Remove Duplicates','Java',1,7,10,0,@baseOrder+19);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print unique elements in original order, space-separated.</p><p>Line 1: n, Line 2: n integers.</p>','1 <= n <= 10^5','6
1 2 2 3 1 4','1 2 3 4','n=int(input())
nums=list(map(int,input().split()))
seen=set()
res=[]
for x in nums:
    if x not in seen:
        res.append(x)
        seen.add(x)
print(*res)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;set<int>seen;bool first=true;for(int x:a){if(!seen.count(x)){if(!first)cout<<" ";cout<<x;first=false;seen.insert(x);}}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();LinkedHashSet<Integer>s=new LinkedHashSet<>();while(n-->0)s.add(sc.nextInt());System.out.println(s.toString().replaceAll("[\\[\\],]","").trim());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const seen=new Set();console.log(L[1].split('' '').map(Number).filter(x=>!seen.has(x)&&seen.add(x)).join('' ''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6
1 2 2 3 1 4','1 2 3 4',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
5 5 5','5',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
3 1 4 1 5','3 1 4 5',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Longest Common Prefix','Java',1,7,10,0,@baseOrder+20);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find longest common prefix of n strings.</p><p>Line 1: n, then n strings.</p>','1 <= n <= 100','3
flower
flow
flight','fl','n=int(input())
words=[input() for _ in range(n)]
p=words[0]
for w in words[1:]:
    while not w.startswith(p):p=p[:-1]
print(p)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<string>v(n);for(auto&s:v)cin>>s;string p=v[0];for(int i=1;i<n;i++){while(v[i].find(p)!=0){p=p.substr(0,p.size()-1);if(p.empty()){cout<<"";return 0;}}}cout<<p;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();String[]w=new String[n];for(int i=0;i<n;i++)w[i]=sc.next();String p=w[0];for(int i=1;i<n;i++){while(!w[i].startsWith(p)){p=p.substring(0,p.length()-1);if(p.isEmpty()){System.out.println("");return;}}}System.out.println(p);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const n=+L[0];const words=L.slice(1,n+1);let p=words[0];for(let i=1;i<words.length;i++){while(!words[i].startsWith(p)){p=p.slice(0,-1);if(!p){console.log('''');return;}}}console.log(p);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
flower
flow
flight','fl',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
dog
racecar','',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1
hello','hello',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Count Occurrences','Java',1,7,10,0,@baseOrder+21);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Count how many times a character appears in string (case-sensitive).</p><p>Line 1: string, Line 2: character</p>','1 <= len(s) <= 1000','hello
l','2','s=input()
c=input()
print(s.count(c))','#include<bits/stdc++.h>
using namespace std;
int main(){string s,c;getline(cin,s);getline(cin,c);cout<<count(s.begin(),s.end(),c[0]);}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);String s=sc.nextLine();char c=sc.nextLine().charAt(0);System.out.println(s.chars().filter(x->x==c).count());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l));rl.on(''close'',()=>{const[s,c]=L;console.log([...s].filter(x=>x===c[0]).length);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello
l','2',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'programming
g','2',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'aaaaaa
a','6',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Matrix Diagonal Sum','Java',1,7,10,0,@baseOrder+22);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print sum of main diagonal elements of n×n matrix.</p><p>Line 1: n, then n lines of n integers.</p>','1 <= n <= 100','3
1 2 3
4 5 6
7 8 9','15','n=int(input())
m=[list(map(int,input().split())) for _ in range(n)]
print(sum(m[i][i] for i in range(n)))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<vector<int>>m(n,vector<int>(n));for(auto&r:m)for(auto&x:r)cin>>x;long long s=0;for(int i=0;i<n;i++)s+=m[i][i];cout<<s;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();long s=0;for(int i=0;i<n;i++){for(int j=0;j<n;j++){int x=sc.nextInt();if(i==j)s+=x;}}System.out.println(s);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const n=+L[0];let s=0;for(let i=0;i<n;i++){const r=L[i+1].split('' '').map(Number);s+=r[i];}console.log(s);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 2 3
4 5 6
7 8 9','15',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
1 2
3 4','5',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
1 0 0 0
0 2 0 0
0 0 3 0
0 0 0 4','10',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Bubble Sort','Java',1,7,10,0,@baseOrder+23);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Sort n integers using Bubble Sort, print sorted array space-separated.</p>','1 <= n <= 1000','5
5 3 1 4 2','1 2 3 4 5','n=int(input())
a=list(map(int,input().split()))
for i in range(n):
    for j in range(n-i-1):
        if a[j]>a[j+1]:a[j],a[j+1]=a[j+1],a[j]
print(*a)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;for(int i=0;i<n;i++)for(int j=0;j<n-i-1;j++)if(a[j]>a[j+1])swap(a[j],a[j+1]);for(int i=0;i<n;i++){if(i)cout<<" ";cout<<a[i];}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();for(int i=0;i<n;i++)for(int j=0;j<n-i-1;j++)if(arr[j]>arr[j+1]){int t=arr[j];arr[j]=arr[j+1];arr[j+1]=t;}System.out.println(Arrays.stream(arr).mapToObj(Integer::toString).reduce((x,y)->x+" "+y).get());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);for(let i=0;i<a.length;i++)for(let j=0;j<a.length-i-1;j++)if(a[j]>a[j+1])[a[j],a[j+1]]=[a[j+1],a[j]];console.log(a.join('' ''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
5 3 1 4 2','1 2 3 4 5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
3 1 2','1 2 3',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
4 3 2 1','1 2 3 4',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Stack using List','Java',1,7,10,0,@baseOrder+24);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Simulate a stack. Line 1: q queries. Each query: PUSH x or POP (print popped, or -1 if empty).</p>','1 <= q <= 1000','4
PUSH 5
PUSH 3
POP
POP','3
5','q=int(input())
stack=[]
for _ in range(q):
    line=input().split()
    if line[0]==''PUSH'':stack.append(int(line[1]))
    else:print(stack.pop() if stack else -1)','#include<bits/stdc++.h>
using namespace std;
int main(){int q;cin>>q;cin.ignore();stack<int>st;while(q--){string line;getline(cin,line);if(line[0]==''P''&&line[1]==''U''){st.push(stoi(line.substr(5)));}else{if(st.empty())cout<<-1<<"\n";else{cout<<st.top()<<"\n";st.pop();}}}}
','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int q=sc.nextInt();sc.nextLine();Deque<Integer>stack=new ArrayDeque<>();while(q-->0){String[]l=sc.nextLine().split(" ");if(l[0].equals("PUSH"))stack.push(Integer.parseInt(l[1]));else System.out.println(stack.isEmpty()?-1:stack.pop());}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const stack=[];const out=[];for(let i=1;i<L.length;i++){const p=L[i].split('' '');if(p[0]===''PUSH'')stack.push(+p[1]);else out.push(stack.length?stack.pop():-1);}console.log(out.join(''\n''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
PUSH 5
PUSH 3
POP
POP','3
5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
POP
PUSH 1','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
PUSH 10
PUSH 20
POP','20',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Pattern - Right Triangle','Java',1,7,10,0,@baseOrder+25);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print a right triangle of stars of height n.</p>','1 <= n <= 20','4','*
**
***
****','n=int(input())
for i in range(1,n+1):print(''*''*i)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;for(int i=1;i<=n;i++){for(int j=0;j<i;j++)cout<<''*'';cout<<"\n";}}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();for(int i=1;i<=n;i++){System.out.println("*".repeat(i));}}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;for(let i=1;i<=n;i++)console.log(''*''.repeat(i));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4','*
**
***
****',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','*',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3','*
**
***',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Kadane''s Algorithm','Java',1,7,10,0,@baseOrder+26);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find maximum subarray sum.</p><p>Line 1: n, Line 2: n integers.</p>','1 <= n <= 10^5','6
-2 1 -3 4 -1 2','5','n=int(input())
a=list(map(int,input().split()))
cur=best=a[0]
for x in a[1:]:
    cur=max(x,cur+x)
    best=max(best,cur)
print(best)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int cur=a[0],best=a[0];for(int i=1;i<n;i++){cur=max(a[i],cur+a[i]);best=max(best,cur);}cout<<best;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();int cur=arr[0],best=arr[0];for(int i=1;i<n;i++){cur=Math.max(arr[i],cur+arr[i]);best=Math.max(best,cur);}System.out.println(best);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);let cur=a[0],best=a[0];for(let i=1;i<a.length;i++){cur=Math.max(a[i],cur+a[i]);best=Math.max(best,cur);}console.log(best);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6
-2 1 -3 4 -1 2','5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
1 2 3 4','10',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
-1 -2 -3','-1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Even or Odd Batch','Java',1,7,10,0,@baseOrder+27);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Line 1: n. For each of next n lines, print EVEN or ODD.</p>','1 <= n <= 100','3
2
7
10','EVEN
ODD
EVEN','n=int(input())
for _ in range(n):
    x=int(input())
    print(''EVEN'' if x%2==0 else ''ODD'')','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;while(n--){int x;cin>>x;cout<<(x%2==0?"EVEN":"ODD")<<"\n";}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();while(n-->0){int x=sc.nextInt();System.out.println(x%2==0?"EVEN":"ODD");}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const n=+L[0];for(let i=1;i<=n;i++)console.log(+L[i]%2===0?''EVEN'':''ODD'');});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
2
7
10','EVEN
ODD
EVEN',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1
0','EVEN',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
-3
4','ODD
EVEN',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Roman to Integer','Java',1,7,10,0,@baseOrder+28);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Convert Roman numeral string to integer.</p>','1 <= len(s) <= 15, valid Roman','XIV','14','s=input().strip()
v={''I'':1,''V'':5,''X'':10,''L'':50,''C'':100,''D'':500,''M'':1000}
res=0
for i in range(len(s)):
    if i+1<len(s) and v[s[i]]<v[s[i+1]]:res-=v[s[i]]
    else:res+=v[s[i]]
print(res)','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;map<char,int>v={{''I'',1},{''V'',5},{''X'',10},{''L'',50},{''C'',100},{''D'',500},{''M'',1000}};int res=0;for(int i=0;i<s.size();i++){if(i+1<s.size()&&v[s[i]]<v[s[i+1]])res-=v[s[i]];else res+=v[s[i]];}cout<<res;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();Map<Character,Integer>v=new HashMap<>();v.put(''I'',1);v.put(''V'',5);v.put(''X'',10);v.put(''L'',50);v.put(''C'',100);v.put(''D'',500);v.put(''M'',1000);int res=0;for(int i=0;i<s.length();i++){if(i+1<s.length()&&v.get(s.charAt(i))<v.get(s.charAt(i+1)))res-=v.get(s.charAt(i));else res+=v.get(s.charAt(i));}System.out.println(res);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const v={I:1,V:5,X:10,L:50,C:100,D:500,M:1000};let res=0;for(let i=0;i<l.length;i++){if(i+1<l.length&&v[l[i]]<v[l[i+1]])res-=v[l[i]];else res+=v[l[i]];}console.log(res);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'XIV','14',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'IX','9',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'MCMXCIV','1994',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Merge Sorted Arrays','Java',1,7,10,0,@baseOrder+29);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Merge two sorted arrays into one sorted array.</p><p>Line 1: n, Line 2: n numbers, Line 3: m, Line 4: m numbers</p>','1 <= n,m <= 10^5','3
1 3 5
3
2 4 6','1 2 3 4 5 6','n=int(input())
a=list(map(int,input().split()))
m=int(input())
b=list(map(int,input().split()))
print(*sorted(a+b))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int m;cin>>m;vector<int>b(m);for(auto&x:b)cin>>x;vector<int>c;merge(a.begin(),a.end(),b.begin(),b.end(),back_inserter(c));for(int i=0;i<c.size();i++){if(i)cout<<" ";cout<<c[i];}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]x=new int[n];for(int i=0;i<n;i++)x[i]=sc.nextInt();int m=sc.nextInt();int[]y=new int[m];for(int i=0;i<m;i++)y[i]=sc.nextInt();int[]z=new int[n+m];System.arraycopy(x,0,z,0,n);System.arraycopy(y,0,z,n,m);Arrays.sort(z);System.out.println(Arrays.stream(z).mapToObj(Integer::toString).reduce((p,q)->p+" "+q).get());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);const b=L[3].split('' '').map(Number);console.log([...a,...b].sort((x,y)=>x-y).join('' ''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 3 5
3
2 4 6','1 2 3 4 5 6',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
1 2
2
3 4','1 2 3 4',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 2 3
3
1 2 3','1 1 2 2 3 3',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Power of Two','Java',1,7,10,0,@baseOrder+30);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print YES if n is a power of 2, else NO.</p>','1 <= n <= 10^18','16','YES','n=int(input())
print(''YES'' if n>0 and (n&(n-1))==0 else ''NO'')','#include<bits/stdc++.h>
using namespace std;
int main(){long long n;cin>>n;cout<<((n>0&&(n&(n-1))==0)?"YES":"NO");}','import java.util.*;
public class Solution{public static void main(String[] a){long n=new Scanner(System.in).nextLong();System.out.println(n>0&&(n&(n-1))==0?"YES":"NO");}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=BigInt(l.trim());console.log(n>0n&&(n&(n-1n))===0n?''YES'':''NO'');rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'16','YES',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6','NO',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','YES',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1024','YES',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'String Compression','Java',1,7,10,0,@baseOrder+31);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Compress string using run-length encoding. e.g. aabccc → a2b1c3</p>','1 <= len(s) <= 1000','aabccc','a2b1c3','s=input().strip()
res=''''
i=0
while i<len(s):
    c=s[i];cnt=0
    while i<len(s) and s[i]==c:cnt+=1;i+=1
    res+=c+str(cnt)
print(res)','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;string res="";int i=0;while(i<s.size()){char c=s[i];int cnt=0;while(i<s.size()&&s[i]==c){cnt++;i++;}res+=c+to_string(cnt);}cout<<res;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();StringBuilder sb=new StringBuilder();int i=0;while(i<s.length()){char c=s.charAt(i);int cnt=0;while(i<s.length()&&s.charAt(i)==c){cnt++;i++;}sb.append(c).append(cnt);}System.out.println(sb);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const s=l.trim();let res='''',i=0;while(i<s.length){let c=s[i],cnt=0;while(i<s.length&&s[i]===c){cnt++;i++;}res+=c+cnt;}console.log(res);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'aabccc','a2b1c3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'abcd','a1b1c1d1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'aaabbb','a3b3',1,2);

-- ═══ ServiceNow ITSM — Coding Questions ═══
SET @tid = (SELECT Id FROM MockTests WHERE Title='ServiceNow ITSM Assessment' ORDER BY Id LIMIT 1);
SET @baseOrder = (SELECT COALESCE(MAX(DisplayOrder),17) FROM MockTestQuestions WHERE MockTestId=@tid);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Reverse a String','ServiceNow',1,7,10,0,@baseOrder+1);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given a string <code>s</code>, return its reverse.</p>','1 <= len(s) <= 1000','hello','olleh','s = input()
print(s[::-1])','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;reverse(s.begin(),s.end());cout<<s;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);String s=sc.next();System.out.println(new StringBuilder(s).reverse());}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log(l.trim().split('''').reverse().join(''''));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello','olleh',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'racecar','racecar',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'python','nohtyp',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'abcde','edcba',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Count Vowels','ServiceNow',1,7,10,0,@baseOrder+2);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Count the number of vowels (a,e,i,o,u) in a string (case-insensitive).</p>','1 <= len(s) <= 1000','Hello World','3','s=input().lower()
print(sum(1 for c in s if c in ''aeiou''))','#include<bits/stdc++.h>
using namespace std;
int main(){string s;getline(cin,s);int c=0;for(char x:s){x=tolower(x);if(string("aeiou").find(x)!=string::npos)c++;}cout<<c;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);String s=sc.nextLine().toLowerCase();long c=s.chars().filter(x->"aeiou".indexOf(x)>=0).count();System.out.println(c);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log([...l.toLowerCase()].filter(c=>''aeiou''.includes(c)).length);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Hello World','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Python','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'AEIOU','5',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'rhythm','0',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Fibonacci','ServiceNow',1,7,10,0,@baseOrder+3);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print the first <code>n</code> Fibonacci numbers, space-separated.</p>','1 <= n <= 30','7','0 1 1 2 3 5 8','n=int(input())
a,b=0,1
res=[]
for _ in range(n):
    res.append(a)
    a,b=b,a+b
print(*res)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;long long a=0,b=1;for(int i=0;i<n;i++){cout<<a;if(i<n-1)cout<<" ";long long c=a+b;a=b;b=c;}}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();long x=0,y=1;StringBuilder sb=new StringBuilder();for(int i=0;i<n;i++){if(i>0)sb.append(" ");sb.append(x);long z=x+y;x=y;y=z;}System.out.println(sb);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;let a=0,b=1,r=[];for(let i=0;i<n;i++){r.push(a);[a,b]=[b,a+b];}console.log(r.join('' ''));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'7','0 1 1 2 3 5 8',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','0',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'10','0 1 1 2 3 5 8 13 21 34',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5','0 1 1 2 3',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Palindrome Check','ServiceNow',1,7,10,0,@baseOrder+4);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print <code>YES</code> if string is palindrome else <code>NO</code>.</p>','1 <= len(s) <= 1000','racecar','YES','s=input().strip()
print(''YES'' if s==s[::-1] else ''NO'')','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;string r=s;reverse(r.begin(),r.end());cout<<(s==r?"YES":"NO");}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();System.out.println(s.equals(new StringBuilder(s).reverse().toString())?"YES":"NO");}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const s=l.trim();console.log(s===s.split('''').reverse().join('''')?''YES'':''NO'');rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'racecar','YES',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello','NO',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'madam','YES',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'level','YES',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Two Sum','ServiceNow',1,7,10,0,@baseOrder+5);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given array of integers and a target, print indices of two numbers that sum to target.</p><p>Line 1: n, Line 2: n numbers, Line 3: target</p>','2 <= n <= 10^4','4
2 7 11 15
9','0 1','n=int(input())
nums=list(map(int,input().split()))
t=int(input())
seen={}
for i,x in enumerate(nums):
    if t-x in seen:
        print(seen[t-x],i)
        break
    seen[x]=i','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int t;cin>>t;map<int,int>m;for(int i=0;i<n;i++){if(m.count(t-a[i])){cout<<m[t-a[i]]<<" "<<i;return 0;}m[a[i]]=i;}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();int t=sc.nextInt();Map<Integer,Integer>m=new HashMap<>();for(int i=0;i<n;i++){if(m.containsKey(t-arr[i])){System.out.println(m.get(t-arr[i])+" "+i);return;}m.put(arr[i],i);}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const nums=L[1].split('' '').map(Number);const t=+L[2];const m={};for(let i=0;i<nums.length;i++){if(m[t-nums[i]]!==undefined){console.log(m[t-nums[i]]+'' ''+i);return;}m[nums[i]]=i;}});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
2 7 11 15
9','0 1',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
3 2 4
6','1 2',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
3 3
6','0 1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'FizzBuzz','ServiceNow',1,7,10,0,@baseOrder+6);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>For 1 to n: print Fizz (div by 3), Buzz (div by 5), FizzBuzz (both), else number.</p>','1 <= n <= 1000','5','1
2
Fizz
4
Buzz','n=int(input())
for i in range(1,n+1):
    if i%15==0:print(''FizzBuzz'')
    elif i%3==0:print(''Fizz'')
    elif i%5==0:print(''Buzz'')
    else:print(i)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;for(int i=1;i<=n;i++){if(i%15==0)cout<<"FizzBuzz\n";else if(i%3==0)cout<<"Fizz\n";else if(i%5==0)cout<<"Buzz\n";else cout<<i<<"\n";}}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();for(int i=1;i<=n;i++){if(i%15==0)System.out.println("FizzBuzz");else if(i%3==0)System.out.println("Fizz");else if(i%5==0)System.out.println("Buzz");else System.out.println(i);}}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;for(let i=1;i<=n;i++){if(i%15===0)console.log(''FizzBuzz'');else if(i%3===0)console.log(''Fizz'');else if(i%5===0)console.log(''Buzz'');else console.log(i);}rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5','1
2
Fizz
4
Buzz',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'15','1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3','1
2
Fizz',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Max in Array','ServiceNow',1,7,10,0,@baseOrder+7);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find maximum value in an array. Line 1: n, Line 2: n integers.</p>','1 <= n <= 10^5','5
3 1 4 1 5','5','n=int(input())
print(max(map(int,input().split())))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;int mx=INT_MIN;for(int i=0;i<n;i++){int x;cin>>x;mx=max(mx,x);}cout<<mx;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int mx=Integer.MIN_VALUE;while(n-->0){int x=sc.nextInt();mx=Math.max(mx,x);}System.out.println(mx);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{console.log(Math.max(...L[1].split('' '').map(Number)));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
3 1 4 1 5','5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
-1 -5 -2','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
0 0 0 1','1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Sum of Digits','ServiceNow',1,7,10,0,@baseOrder+8);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given a non-negative integer, print the sum of its digits.</p>','0 <= n <= 10^18','1234','10','print(sum(int(c) for c in input().strip()))','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;int t=0;for(char c:s)t+=c-''0'';cout<<t;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();int t=0;for(char c:s.toCharArray())t+=c-''0'';System.out.println(t);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log([...l.trim()].reduce((s,c)=>s+parseInt(c),0));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1234','10',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'999','27',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'0','0',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'100','1',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Prime Check','ServiceNow',1,7,10,0,@baseOrder+9);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print <code>PRIME</code> or <code>NOT PRIME</code>.</p>','1 <= n <= 10^6','17','PRIME','n=int(input())
if n<2:print(''NOT PRIME'')
else:print(''PRIME'' if all(n%i!=0 for i in range(2,int(n**0.5)+1)) else ''NOT PRIME'')','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;if(n<2){cout<<"NOT PRIME";return 0;}for(int i=2;i*i<=n;i++)if(n%i==0){cout<<"NOT PRIME";return 0;}cout<<"PRIME";}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();if(n<2){System.out.println("NOT PRIME");return;}for(int i=2;i*i<=n;i++)if(n%i==0){System.out.println("NOT PRIME");return;}System.out.println("PRIME");}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;if(n<2){console.log(''NOT PRIME'');rl.close();return;}for(let i=2;i*i<=n;i++)if(n%i===0){console.log(''NOT PRIME'');rl.close();return;}console.log(''PRIME'');rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'17','PRIME',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4','NOT PRIME',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','NOT PRIME',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'97','PRIME',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Factorial','ServiceNow',1,7,10,0,@baseOrder+10);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print n! (n <= 15).</p>','0 <= n <= 15','5','120','import math
print(math.factorial(int(input())))','#include<bits/stdc++.h>
using namespace std;
int main(){long long n,f=1;cin>>n;for(long long i=1;i<=n;i++)f*=i;cout<<f;}','import java.util.*;
public class Solution{public static void main(String[] a){long n=new Scanner(System.in).nextLong();long f=1;for(long i=1;i<=n;i++)f*=i;System.out.println(f);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{let n=+l,f=1;for(let i=1;i<=n;i++)f*=i;console.log(f);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5','120',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'0','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'10','3628800',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'12','479001600',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Binary Search','ServiceNow',1,7,10,0,@baseOrder+11);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given sorted array and target, print index (0-based) or -1 if not found.</p><p>Line 1: n, Line 2: sorted integers, Line 3: target</p>','1 <= n <= 10^5','5
1 3 5 7 9
7','3','n=int(input())
arr=list(map(int,input().split()))
t=int(input())
l,r=0,n-1
while l<=r:
    m=(l+r)//2
    if arr[m]==t:print(m);exit()
    elif arr[m]<t:l=m+1
    else:r=m-1
print(-1)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int t;cin>>t;int l=0,r=n-1;while(l<=r){int m=(l+r)/2;if(a[m]==t){cout<<m;return 0;}else if(a[m]<t)l=m+1;else r=m-1;}cout<<-1;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();int t=sc.nextInt(),l=0,r=n-1;while(l<=r){int m=(l+r)/2;if(arr[m]==t){System.out.println(m);return;}else if(arr[m]<t)l=m+1;else r=m-1;}System.out.println(-1);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);const t=+L[2];let l=0,r=a.length-1;while(l<=r){const m=Math.floor((l+r)/2);if(a[m]===t){console.log(m);return;}else if(a[m]<t)l=m+1;else r=m-1;}console.log(-1);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
1 3 5 7 9
7','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 2 3
4','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6
2 4 6 8 10 12
10','4',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Word Count','ServiceNow',1,7,10,0,@baseOrder+12);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print the number of words in a sentence.</p>','1 <= len(s) <= 1000','Hello World how are you','5','print(len(input().split()))','#include<bits/stdc++.h>
using namespace std;
int main(){string line;getline(cin,line);istringstream iss(line);int c=0;string w;while(iss>>w)c++;cout<<c;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).nextLine().trim();System.out.println(s.isEmpty()?0:s.split("\\s+").length);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log(l.trim().split(/\s+/).filter(Boolean).length);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Hello World how are you','5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'one','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Python is awesome','3',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Anagram Check','ServiceNow',1,7,10,0,@baseOrder+13);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Given two strings on separate lines, print YES if anagrams else NO (case-insensitive).</p>','1 <= len <= 1000','listen
silent','YES','a,b=input().lower(),input().lower()
print(''YES'' if sorted(a)==sorted(b) else ''NO'')','#include<bits/stdc++.h>
using namespace std;
int main(){string a,b;cin>>a>>b;for(auto&c:a)c=tolower(c);for(auto&c:b)c=tolower(c);sort(a.begin(),a.end());sort(b.begin(),b.end());cout<<(a==b?"YES":"NO");}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);char[]x=sc.next().toLowerCase().toCharArray();char[]y=sc.next().toLowerCase().toCharArray();Arrays.sort(x);Arrays.sort(y);System.out.println(Arrays.equals(x,y)?"YES":"NO");}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim().toLowerCase()));rl.on(''close'',()=>{console.log([...L[0]].sort().join('''')===[...L[1]].sort().join('''')?''YES'':''NO'');});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'listen
silent','YES',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello
world','NO',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'triangle
integral','YES',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Largest Palindrome Substring Length','ServiceNow',1,7,10,0,@baseOrder+14);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find the length of the longest palindromic substring.</p>','1 <= len(s) <= 1000','babad','3','s=input().strip()
n=len(s)
best=1
for i in range(n):
    for r in range(2):
        l,ri=i,i+r
        while l>=0 and ri<n and s[l]==s[ri]:
            best=max(best,ri-l+1)
            l-=1;ri+=1
print(best)','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;int n=s.size(),best=1;for(int i=0;i<n;i++)for(int r=0;r<2;r++){int l=i,ri=i+r;while(l>=0&&ri<n&&s[l]==s[ri]){best=max(best,ri-l+1);l--;ri++;}}cout<<best;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();int n=s.length(),best=1;for(int i=0;i<n;i++)for(int r=0;r<2;r++){int l=i,ri=i+r;while(l>=0&&ri<n&&s.charAt(l)==s.charAt(ri)){best=Math.max(best,ri-l+1);l--;ri++;}}System.out.println(best);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const s=l.trim();let best=1;for(let i=0;i<s.length;i++)for(let r=0;r<2;r++){let[L,ri]=[i,i+r];while(L>=0&&ri<s.length&&s[L]===s[ri]){best=Math.max(best,ri-L+1);L--;ri++;}}console.log(best);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'babad','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'cbbd','2',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'racecar','7',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Sum of Array','ServiceNow',1,7,10,0,@baseOrder+15);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print sum of n integers. Line 1: n, Line 2: n numbers.</p>','1 <= n <= 10^5','5
1 2 3 4 5','15','n=int(input())
print(sum(map(int,input().split())))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;long long s=0;for(int i=0;i<n;i++){int x;cin>>x;s+=x;}cout<<s;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();long s=0;while(n-->0)s+=sc.nextLong();System.out.println(s);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{console.log(L[1].split('' '').reduce((a,b)=>a+ +b,0));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
1 2 3 4 5','15',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
-1 0 1','0',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1
100','100',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Count Words Starting With Vowel','ServiceNow',1,7,10,0,@baseOrder+16);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Count words in sentence that start with a vowel (case-insensitive).</p>','1 <= len(s) <= 1000','apple is an orange','3','s=input().lower()
print(sum(1 for w in s.split() if w[0] in ''aeiou''))','#include<bits/stdc++.h>
using namespace std;
int main(){string line;getline(cin,line);istringstream iss(line);string w;int c=0;while(iss>>w){char ch=tolower(w[0]);if(string("aeiou").find(ch)!=string::npos)c++;}cout<<c;}','import java.util.*;
public class Solution{public static void main(String[] a){String[]ws=new Scanner(System.in).nextLine().toLowerCase().split("\\s+");long c=Arrays.stream(ws).filter(w->"aeiou".indexOf(w.charAt(0))>=0).count();System.out.println(c);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{console.log(l.toLowerCase().split(/\s+/).filter(w=>''aeiou''.includes(w[0])).length);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'apple is an orange','3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello world','1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'Every Algorithm Is Optimal','4',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'GCD of Two Numbers','ServiceNow',1,7,10,0,@baseOrder+17);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print GCD of two space-separated integers.</p>','1 <= a,b <= 10^9','12 8','4','a,b=map(int,input().split())
from math import gcd
print(gcd(a,b))','#include<bits/stdc++.h>
using namespace std;
int main(){long long a,b;cin>>a>>b;cout<<__gcd(a,b);}','import java.util.*;
public class Solution{static long gcd(long a,long b){return b==0?a:gcd(b,a%b);}public static void main(String[] a){Scanner sc=new Scanner(System.in);System.out.println(gcd(sc.nextLong(),sc.nextLong()));}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const[a,b]=l.split('' '').map(Number);const g=(x,y)=>y===0?x:g(y,x%y);console.log(g(a,b));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'12 8','4',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'100 75','25',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'17 13','1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Second Largest','ServiceNow',1,7,10,0,@baseOrder+18);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find the second largest unique element. Print -1 if none.</p><p>Line 1: n, Line 2: n integers.</p>','2 <= n <= 10^5','5
3 1 4 1 5','4','n=int(input())
nums=list(map(int,input().split()))
uniq=sorted(set(nums))
print(uniq[-2] if len(uniq)>=2 else -1)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;set<int>s;for(int i=0;i<n;i++){int x;cin>>x;s.insert(x);}auto it=s.end();--it;if(it==s.begin())cout<<-1;else{--it;cout<<*it;}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();TreeSet<Integer>s=new TreeSet<>();while(n-->0)s.add(sc.nextInt());if(s.size()<2)System.out.println(-1);else{s.pollLast();System.out.println(s.last());}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const s=[...new Set(L[1].split('' '').map(Number))].sort((a,b)=>a-b);console.log(s.length>=2?s[s.length-2]:-1);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
3 1 4 1 5','4',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
5 5 5','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
10 20 30 40','30',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Remove Duplicates','ServiceNow',1,7,10,0,@baseOrder+19);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print unique elements in original order, space-separated.</p><p>Line 1: n, Line 2: n integers.</p>','1 <= n <= 10^5','6
1 2 2 3 1 4','1 2 3 4','n=int(input())
nums=list(map(int,input().split()))
seen=set()
res=[]
for x in nums:
    if x not in seen:
        res.append(x)
        seen.add(x)
print(*res)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;set<int>seen;bool first=true;for(int x:a){if(!seen.count(x)){if(!first)cout<<" ";cout<<x;first=false;seen.insert(x);}}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();LinkedHashSet<Integer>s=new LinkedHashSet<>();while(n-->0)s.add(sc.nextInt());System.out.println(s.toString().replaceAll("[\\[\\],]","").trim());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const seen=new Set();console.log(L[1].split('' '').map(Number).filter(x=>!seen.has(x)&&seen.add(x)).join('' ''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6
1 2 2 3 1 4','1 2 3 4',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
5 5 5','5',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
3 1 4 1 5','3 1 4 5',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Longest Common Prefix','ServiceNow',1,7,10,0,@baseOrder+20);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find longest common prefix of n strings.</p><p>Line 1: n, then n strings.</p>','1 <= n <= 100','3
flower
flow
flight','fl','n=int(input())
words=[input() for _ in range(n)]
p=words[0]
for w in words[1:]:
    while not w.startswith(p):p=p[:-1]
print(p)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<string>v(n);for(auto&s:v)cin>>s;string p=v[0];for(int i=1;i<n;i++){while(v[i].find(p)!=0){p=p.substr(0,p.size()-1);if(p.empty()){cout<<"";return 0;}}}cout<<p;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();String[]w=new String[n];for(int i=0;i<n;i++)w[i]=sc.next();String p=w[0];for(int i=1;i<n;i++){while(!w[i].startsWith(p)){p=p.substring(0,p.length()-1);if(p.isEmpty()){System.out.println("");return;}}}System.out.println(p);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const n=+L[0];const words=L.slice(1,n+1);let p=words[0];for(let i=1;i<words.length;i++){while(!words[i].startsWith(p)){p=p.slice(0,-1);if(!p){console.log('''');return;}}}console.log(p);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
flower
flow
flight','fl',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
dog
racecar','',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1
hello','hello',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Count Occurrences','ServiceNow',1,7,10,0,@baseOrder+21);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Count how many times a character appears in string (case-sensitive).</p><p>Line 1: string, Line 2: character</p>','1 <= len(s) <= 1000','hello
l','2','s=input()
c=input()
print(s.count(c))','#include<bits/stdc++.h>
using namespace std;
int main(){string s,c;getline(cin,s);getline(cin,c);cout<<count(s.begin(),s.end(),c[0]);}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);String s=sc.nextLine();char c=sc.nextLine().charAt(0);System.out.println(s.chars().filter(x->x==c).count());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l));rl.on(''close'',()=>{const[s,c]=L;console.log([...s].filter(x=>x===c[0]).length);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'hello
l','2',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'programming
g','2',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'aaaaaa
a','6',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Matrix Diagonal Sum','ServiceNow',1,7,10,0,@baseOrder+22);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print sum of main diagonal elements of n×n matrix.</p><p>Line 1: n, then n lines of n integers.</p>','1 <= n <= 100','3
1 2 3
4 5 6
7 8 9','15','n=int(input())
m=[list(map(int,input().split())) for _ in range(n)]
print(sum(m[i][i] for i in range(n)))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<vector<int>>m(n,vector<int>(n));for(auto&r:m)for(auto&x:r)cin>>x;long long s=0;for(int i=0;i<n;i++)s+=m[i][i];cout<<s;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();long s=0;for(int i=0;i<n;i++){for(int j=0;j<n;j++){int x=sc.nextInt();if(i==j)s+=x;}}System.out.println(s);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const n=+L[0];let s=0;for(let i=0;i<n;i++){const r=L[i+1].split('' '').map(Number);s+=r[i];}console.log(s);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 2 3
4 5 6
7 8 9','15',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
1 2
3 4','5',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
1 0 0 0
0 2 0 0
0 0 3 0
0 0 0 4','10',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Bubble Sort','ServiceNow',1,7,10,0,@baseOrder+23);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Sort n integers using Bubble Sort, print sorted array space-separated.</p>','1 <= n <= 1000','5
5 3 1 4 2','1 2 3 4 5','n=int(input())
a=list(map(int,input().split()))
for i in range(n):
    for j in range(n-i-1):
        if a[j]>a[j+1]:a[j],a[j+1]=a[j+1],a[j]
print(*a)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;for(int i=0;i<n;i++)for(int j=0;j<n-i-1;j++)if(a[j]>a[j+1])swap(a[j],a[j+1]);for(int i=0;i<n;i++){if(i)cout<<" ";cout<<a[i];}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();for(int i=0;i<n;i++)for(int j=0;j<n-i-1;j++)if(arr[j]>arr[j+1]){int t=arr[j];arr[j]=arr[j+1];arr[j+1]=t;}System.out.println(Arrays.stream(arr).mapToObj(Integer::toString).reduce((x,y)->x+" "+y).get());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);for(let i=0;i<a.length;i++)for(let j=0;j<a.length-i-1;j++)if(a[j]>a[j+1])[a[j],a[j+1]]=[a[j+1],a[j]];console.log(a.join('' ''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'5
5 3 1 4 2','1 2 3 4 5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
3 1 2','1 2 3',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
4 3 2 1','1 2 3 4',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Stack using List','ServiceNow',1,7,10,0,@baseOrder+24);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Simulate a stack. Line 1: q queries. Each query: PUSH x or POP (print popped, or -1 if empty).</p>','1 <= q <= 1000','4
PUSH 5
PUSH 3
POP
POP','3
5','q=int(input())
stack=[]
for _ in range(q):
    line=input().split()
    if line[0]==''PUSH'':stack.append(int(line[1]))
    else:print(stack.pop() if stack else -1)','#include<bits/stdc++.h>
using namespace std;
int main(){int q;cin>>q;cin.ignore();stack<int>st;while(q--){string line;getline(cin,line);if(line[0]==''P''&&line[1]==''U''){st.push(stoi(line.substr(5)));}else{if(st.empty())cout<<-1<<"\n";else{cout<<st.top()<<"\n";st.pop();}}}}
','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int q=sc.nextInt();sc.nextLine();Deque<Integer>stack=new ArrayDeque<>();while(q-->0){String[]l=sc.nextLine().split(" ");if(l[0].equals("PUSH"))stack.push(Integer.parseInt(l[1]));else System.out.println(stack.isEmpty()?-1:stack.pop());}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const stack=[];const out=[];for(let i=1;i<L.length;i++){const p=L[i].split('' '');if(p[0]===''PUSH'')stack.push(+p[1]);else out.push(stack.length?stack.pop():-1);}console.log(out.join(''\n''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
PUSH 5
PUSH 3
POP
POP','3
5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
POP
PUSH 1','-1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
PUSH 10
PUSH 20
POP','20',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Pattern - Right Triangle','ServiceNow',1,7,10,0,@baseOrder+25);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print a right triangle of stars of height n.</p>','1 <= n <= 20','4','*
**
***
****','n=int(input())
for i in range(1,n+1):print(''*''*i)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;for(int i=1;i<=n;i++){for(int j=0;j<i;j++)cout<<''*'';cout<<"\n";}}','import java.util.*;
public class Solution{public static void main(String[] a){int n=new Scanner(System.in).nextInt();for(int i=1;i<=n;i++){System.out.println("*".repeat(i));}}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=+l;for(let i=1;i<=n;i++)console.log(''*''.repeat(i));rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4','*
**
***
****',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','*',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3','*
**
***',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Kadane''s Algorithm','ServiceNow',1,7,10,0,@baseOrder+26);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Find maximum subarray sum.</p><p>Line 1: n, Line 2: n integers.</p>','1 <= n <= 10^5','6
-2 1 -3 4 -1 2','5','n=int(input())
a=list(map(int,input().split()))
cur=best=a[0]
for x in a[1:]:
    cur=max(x,cur+x)
    best=max(best,cur)
print(best)','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int cur=a[0],best=a[0];for(int i=1;i<n;i++){cur=max(a[i],cur+a[i]);best=max(best,cur);}cout<<best;}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]arr=new int[n];for(int i=0;i<n;i++)arr[i]=sc.nextInt();int cur=arr[0],best=arr[0];for(int i=1;i<n;i++){cur=Math.max(arr[i],cur+arr[i]);best=Math.max(best,cur);}System.out.println(best);}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);let cur=a[0],best=a[0];for(let i=1;i<a.length;i++){cur=Math.max(a[i],cur+a[i]);best=Math.max(best,cur);}console.log(best);});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6
-2 1 -3 4 -1 2','5',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'4
1 2 3 4','10',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
-1 -2 -3','-1',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Even or Odd Batch','ServiceNow',1,7,10,0,@baseOrder+27);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Line 1: n. For each of next n lines, print EVEN or ODD.</p>','1 <= n <= 100','3
2
7
10','EVEN
ODD
EVEN','n=int(input())
for _ in range(n):
    x=int(input())
    print(''EVEN'' if x%2==0 else ''ODD'')','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;while(n--){int x;cin>>x;cout<<(x%2==0?"EVEN":"ODD")<<"\n";}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();while(n-->0){int x=sc.nextInt();System.out.println(x%2==0?"EVEN":"ODD");}}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const n=+L[0];for(let i=1;i<=n;i++)console.log(+L[i]%2===0?''EVEN'':''ODD'');});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
2
7
10','EVEN
ODD
EVEN',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1
0','EVEN',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
-3
4','ODD
EVEN',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Roman to Integer','ServiceNow',1,7,10,0,@baseOrder+28);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Convert Roman numeral string to integer.</p>','1 <= len(s) <= 15, valid Roman','XIV','14','s=input().strip()
v={''I'':1,''V'':5,''X'':10,''L'':50,''C'':100,''D'':500,''M'':1000}
res=0
for i in range(len(s)):
    if i+1<len(s) and v[s[i]]<v[s[i+1]]:res-=v[s[i]]
    else:res+=v[s[i]]
print(res)','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;map<char,int>v={{''I'',1},{''V'',5},{''X'',10},{''L'',50},{''C'',100},{''D'',500},{''M'',1000}};int res=0;for(int i=0;i<s.size();i++){if(i+1<s.size()&&v[s[i]]<v[s[i+1]])res-=v[s[i]];else res+=v[s[i]];}cout<<res;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();Map<Character,Integer>v=new HashMap<>();v.put(''I'',1);v.put(''V'',5);v.put(''X'',10);v.put(''L'',50);v.put(''C'',100);v.put(''D'',500);v.put(''M'',1000);int res=0;for(int i=0;i<s.length();i++){if(i+1<s.length()&&v.get(s.charAt(i))<v.get(s.charAt(i+1)))res-=v.get(s.charAt(i));else res+=v.get(s.charAt(i));}System.out.println(res);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const v={I:1,V:5,X:10,L:50,C:100,D:500,M:1000};let res=0;for(let i=0;i<l.length;i++){if(i+1<l.length&&v[l[i]]<v[l[i+1]])res-=v[l[i]];else res+=v[l[i]];}console.log(res);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'XIV','14',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'IX','9',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'MCMXCIV','1994',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Merge Sorted Arrays','ServiceNow',1,7,10,0,@baseOrder+29);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Merge two sorted arrays into one sorted array.</p><p>Line 1: n, Line 2: n numbers, Line 3: m, Line 4: m numbers</p>','1 <= n,m <= 10^5','3
1 3 5
3
2 4 6','1 2 3 4 5 6','n=int(input())
a=list(map(int,input().split()))
m=int(input())
b=list(map(int,input().split()))
print(*sorted(a+b))','#include<bits/stdc++.h>
using namespace std;
int main(){int n;cin>>n;vector<int>a(n);for(auto&x:a)cin>>x;int m;cin>>m;vector<int>b(m);for(auto&x:b)cin>>x;vector<int>c;merge(a.begin(),a.end(),b.begin(),b.end(),back_inserter(c));for(int i=0;i<c.size();i++){if(i)cout<<" ";cout<<c[i];}}','import java.util.*;
public class Solution{public static void main(String[] a){Scanner sc=new Scanner(System.in);int n=sc.nextInt();int[]x=new int[n];for(int i=0;i<n;i++)x[i]=sc.nextInt();int m=sc.nextInt();int[]y=new int[m];for(int i=0;i<m;i++)y[i]=sc.nextInt();int[]z=new int[n+m];System.arraycopy(x,0,z,0,n);System.arraycopy(y,0,z,n,m);Arrays.sort(z);System.out.println(Arrays.stream(z).mapToObj(Integer::toString).reduce((p,q)->p+" "+q).get());}}','const rl=require(''readline'').createInterface({input:process.stdin});const L=[];rl.on(''line'',l=>L.push(l.trim()));rl.on(''close'',()=>{const a=L[1].split('' '').map(Number);const b=L[3].split('' '').map(Number);console.log([...a,...b].sort((x,y)=>x-y).join('' ''));});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 3 5
3
2 4 6','1 2 3 4 5 6',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'2
1 2
2
3 4','1 2 3 4',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'3
1 2 3
3
1 2 3','1 1 2 2 3 3',1,2);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'Power of Two','ServiceNow',1,7,10,0,@baseOrder+30);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Print YES if n is a power of 2, else NO.</p>','1 <= n <= 10^18','16','YES','n=int(input())
print(''YES'' if n>0 and (n&(n-1))==0 else ''NO'')','#include<bits/stdc++.h>
using namespace std;
int main(){long long n;cin>>n;cout<<((n>0&&(n&(n-1))==0)?"YES":"NO");}','import java.util.*;
public class Solution{public static void main(String[] a){long n=new Scanner(System.in).nextLong();System.out.println(n>0&&(n&(n-1))==0?"YES":"NO");}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const n=BigInt(l.trim());console.log(n>0n&&(n&(n-1n))===0n?''YES'':''NO'');rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'16','YES',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'6','NO',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1','YES',1,2);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'1024','YES',1,3);
INSERT INTO MockTestQuestions (MockTestId,Text,Topic,Difficulty,QuestionType,Marks,NegativeMarks,DisplayOrder)
VALUES (@tid,'String Compression','ServiceNow',1,7,10,0,@baseOrder+31);
SET @cqid = LAST_INSERT_ID();
INSERT INTO CodingQuestions (MockTestQuestionId,ProblemStatement,Constraints,SampleInput,SampleOutput,StarterCodePython,StarterCodeCpp,StarterCodeJava,StarterCodeJs)
VALUES (@cqid,'<p>Compress string using run-length encoding. e.g. aabccc → a2b1c3</p>','1 <= len(s) <= 1000','aabccc','a2b1c3','s=input().strip()
res=''''
i=0
while i<len(s):
    c=s[i];cnt=0
    while i<len(s) and s[i]==c:cnt+=1;i+=1
    res+=c+str(cnt)
print(res)','#include<bits/stdc++.h>
using namespace std;
int main(){string s;cin>>s;string res="";int i=0;while(i<s.size()){char c=s[i];int cnt=0;while(i<s.size()&&s[i]==c){cnt++;i++;}res+=c+to_string(cnt);}cout<<res;}','import java.util.*;
public class Solution{public static void main(String[] a){String s=new Scanner(System.in).next();StringBuilder sb=new StringBuilder();int i=0;while(i<s.length()){char c=s.charAt(i);int cnt=0;while(i<s.length()&&s.charAt(i)==c){cnt++;i++;}sb.append(c).append(cnt);}System.out.println(sb);}}','const rl=require(''readline'').createInterface({input:process.stdin});rl.on(''line'',l=>{const s=l.trim();let res='''',i=0;while(i<s.length){let c=s[i],cnt=0;while(i<s.length&&s[i]===c){cnt++;i++;}res+=c+cnt;}console.log(res);rl.close();});');
SET @cqdetail = LAST_INSERT_ID();
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'aabccc','a2b1c3',0,0);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'abcd','a1b1c1d1',0,1);
INSERT INTO TestCases (CodingQuestionId,Input,ExpectedOutput,IsHidden,DisplayOrder) VALUES (@cqdetail,'aaabbb','a3b3',1,2);

-- Step 2: Ensure exactly 18 MCQ shown + 2 coding (fixed order)
-- Set DisplayOrder: MCQ questions get order 1-18, coding get 19-20 (last 2 forced)

-- For each exam: renumber MCQ questions 1..18, coding questions 19..20
-- This ensures coding always appears last
UPDATE MockTestQuestions q
JOIN (
    SELECT Id, ROW_NUMBER() OVER (PARTITION BY MockTestId ORDER BY QuestionType, DisplayOrder) as rn
    FROM MockTestQuestions
    WHERE QuestionType != 7  -- non-coding first
) ranked ON q.Id = ranked.Id
SET q.DisplayOrder = ranked.rn
WHERE q.QuestionType != 7;

UPDATE MockTestQuestions q
JOIN (
    SELECT Id, 18 + ROW_NUMBER() OVER (PARTITION BY MockTestId ORDER BY DisplayOrder) as rn
    FROM MockTestQuestions
    WHERE QuestionType = 7  -- coding last
) ranked ON q.Id = ranked.Id
SET q.DisplayOrder = ranked.rn
WHERE q.QuestionType = 7;

SET FOREIGN_KEY_CHECKS=1;

-- Verify:
SELECT t.Title, COUNT(DISTINCT q.Id) as Total,
  SUM(CASE WHEN q.QuestionType=7 THEN 1 ELSE 0 END) as CodingQs,
  SUM(CASE WHEN q.QuestionType!=7 THEN 1 ELSE 0 END) as MCQs,
  t.TotalQuestions as ShowPerExam
FROM MockTests t LEFT JOIN MockTestQuestions q ON q.MockTestId=t.Id
GROUP BY t.Id, t.Title, t.TotalQuestions ORDER BY t.Id;
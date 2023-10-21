# PAD Lab1
A microservices based API for a school management app, an LMS (Learning Management Systems)


### Assess Application Suitability. 

#### Why not a monolith?

* **The application can grow big and cause very slow deployments.** There are a lot of features that 
can be added further such as a chat service, a calendar integration service, statistics service,
legal documents service, student admission, online quizzes.
* **Inability to deploy a particular part of the application independently**. If only one small part of the
application required a change, such as fixing a bug with students list endpoint, this may cause the slow redeployment
of the entire application. Some parts of the system may remain unchanged, while other may require multiple deployments
often. In case of a slow deployment, this would cause a long downtime and system unavailability, but teachers and 
students will require to access the system during the lessons on demand, in order to put marks and to record
attendance, in order to submit homework. The schools can be situated across the glob, so deploying only at night 
is not a solution because of time differences in clients.
* **A bug in one function may cause the entire system to go down at once**. For example an administrator might try
to create a school, a critical bug may happen, and the entire system will go down. The teachers will not be able
to record attendance and puts marks.
* **Limited vertical scalability** The more logic the monolith encapsulates, the more computer resources are needed,
but there are certain limitations on CPUs and RAMs.
* **Slower services in the monolith may cause delays for the rest of system**. For example, there might be a 
statistic feature, that would provide monthly and yearly statistics about attendance, marks, homeworks. This service
would be slower and may cause delays for the rest of the application. Separating may reduce load on the
entire system, increasing system availability and reducing latency.
* **Some security issues may cause unauthorised access to all components at once**

#### Why microservices?

* **Independent horizontal scaling**: Microservices are easier and often cheaper to scale horizontally. Monolithic
applications are usually resource-heavy and running them on numerous instances could be
quite expensive due to high hardware requirements. Microservices, however, can be scaled
independently. So, if a particular part of the system requires running on hundreds or thousands
of servers, other parts don't need to follow the same requirements. For example, the service responsible for
marking attendance, or passing quizzes may require more servers and thus can be scaled individually.
* **More independence in code development**
* **Technological freedom** Some services may require to be written in some specific technologies. For example the 
chat service.

Some similar LMS systems that employ microservices are: edX, canvas, Google Classroom.

## Define Service Boundaries

There will be 3 main microservices:
1. **User Service** - responsible for creating users, authentication and authorization of users
2. **Schools Administration Service** - responsible for creating schools, new semesters, classes
3. **Lessons Service** - responsible for creating courses and lessons, marking attendance and registering marks, 
viewing the schedule

System architecture diagram: 

![ArchitectureDiagramPAD](https://github.com/EliriaT/school-api/assets/67596753/d2e82d48-7f50-4986-8158-b4b9b7adbb8e)


## Choose Technology Stack and Communication Patterns

The chosen programming language for the services is Go. Go provides simplicity in writing network and concurrent applications. 
Network calls, data serialization, encoding are done with ease in Go with just the standard library.
The final application represents a simple native compiled binary, which makes it very easy to deploy.
Explicit error handling in Go ensures that services handle different failures in a right way.

The API gateway will be written in Elixir.

The external client (front-end app e.g.) will communicate with the API Gateway
through a RESTful API. The microservices will communicate through RPC calls between themselves and with the API Gateway.
The Gateway will serve as synchronous RPC Client, and thus the communication will be synchronous.

## Design Data Management

Each service will have each its own PostgreSQL database.

### **User Service**

![User Service](https://github.com/EliriaT/school-api/assets/67596753/18a114f9-f38b-474f-b8f3-cfd8f82b4171)

### **Schools Administration Service**

![Schools Administration Service(1)](https://github.com/EliriaT/school-api/assets/67596753/c738bd33-63a6-44a6-a2a6-1e70ca48e916)


### **Lessons Service**

![LessonsService](https://github.com/EliriaT/school-api/assets/67596753/e44665b9-afac-4775-91ea-4b640b8c4d24)

### **Endpoints**

The list of endpoints provided to the client by the API Gateway:

* **User Service**

`– POST /users` - Creates a users. Authentication middleware is applied to the endpoint. Only some roles can
create users. **Authorization header required**

<details>
           <summary>Request Body</summary>
          
```
{
    "email" : "irinatiora7@gmail.com",
    "lastName" : "Tiora",
    "firstName": "Irina",
    "school_id":1,
    "role_id":2,
    "class_id":0
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "id": 2,
    "email": "irinatiora7@gmail.com",
    "lastName": "Tiora",
    "firstName": "Irina",
    "passwordChangedAt": "0001-01-01T00:00:00Z",
    "createdAt": "2023-09-27T04:56:50.346801Z",
    "school_id": 1,
    "role_id": 2
}
```
</details>

`– POST /users/login` -  Login to the service. This endpoint returns the Access token.

<details>
           <summary>Request Body</summary>

```
{
    "email":"irinaAdmin@gmail.com",
    "password" :"1234567"
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "token" : "v4.local.5Y91o9Gpgi56F7T3HPZO9RWPsDfDUdnD_N9A2flYzFTqWFlNZRXJVciENq1giChiQZm1lvayZIKIkxJPnwcWd_qoZBra4n1FvdoeabLtKDTmzteM9D4GJ1JSGvKR2WwH2Oyx6YK1_2IIrUyQiT1-Q3akC-epFaengnm7d30-Lar9fwSbfAK3FtL-EZsYF_yKDY5-JH6Ljw6sL0j689OqBKgdU1J9zbheJhv88KSbC34mlXSVMeyYRK8wJt_dV2d2ebQ8i5_Qdm8OapQHzLG8UMnaNnMiwnCkP1lSqecT2PiEkGuDth41WrUou-YMVAljHT64YmvpPQe7CYEMPRl9Z0FD79sbKFLcVQXlVNo-zDnYQ56enr9QIDbZlkOfS_ef-Rcdv67x6E1uJeLk9Hff4GdlbDCLfAmXaw",
}
```
</details>

`– GEY /users/:id` - Get a user by id

* **Schools Administration Service**

`– POST /schools` - Creates a school. Admin only access. 

<details>
           <summary>Request Body</summary>

```
{
    "name" :  "I.P.L.T. Mihai Viteazu"
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "id": 3,
    "name": "I.P.L.T. Mihai Viteazu",
    "createdAt": "2023-09-27T16:52:04.804778Z",
    "updatedAt": "0001-01-01T00:00:00Z"
}
```
</details>


`– POST /class ` -  Creates a class. Director’s and manager’s school only access. 

<details>
           <summary>Request Body</summary>

```
{
    "name" :  "Clasa 6",
    "head_teacher": 2
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "id": 1,
    "name": "Clasa 6",
    "head_teacher": 2,
    "school_id": 4,
    "createdAt": "0001-01-01T00:00:00Z",
    "updatedAt": "0001-01-01T00:00:00Z"
}
```
</details>

`– GET /class` -  Response is based on user’s role. If it is a director or school manager, all classes are returned,
otherwise the user’s class. 

<details>
           <summary>Response Body</summary>

```
[
    {
        "id": 1,
        "name": "Clasa 6",
        "head_teacher": 3,
        "school_id": 4,
        "head_teacher_name": "Noroc Viorel",
        "createdAt": "0001-01-01T00:00:00Z",
        "updatedAt": "0001-01-01T00:00:00Z"
    }
]
```
</details>

`– POST /semester` - Creates a semester. Access limited to director and manager

<details>
           <summary>Request Body</summary>

```
{
    "name":"Semestru 1",
    "start_date":"2022-09-11T00:00:00Z",
    "end_date":"2023-01-10T00:00:00Z"
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "id": 1,
    "name": "Semestru 1",
    "start_date": "2022-09-11T00:00:00Z",
    "end_date": "2023-01-10T00:00:00Z",
    "school_id": 1,
    "createdAt": "2023-09-27T16:58:24.392629Z",
    "updatedAt": "0001-01-01T00:00:00Z"
}
```
</details>

* **Lessons Service**

`– POST /course` - Creates a course. Access limited to director and manager

<details>
           <summary>Request Body</summary>

```
{
    "name":"Matematica",
    "teacher_id":3,
    "semester_id":1,
    "class_id":1
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "id": 2,
    "name": "Matematica",
    "teacher_id": 3,
    "semester_id": 1,
    "class_id": 1,
    "createdAt": "2023-09-27T17:04:49.9149Z",
    "updatedAt": "0001-01-01T00:00:00Z"
}
```
</details>

`– GET /course/:id` - Get students list together with their marks. A student will receive in the response only their
marks, a teacher will see all marks to their taught subject.

<details>
           <summary>Response Body</summary>

```
{
    "id": 2,
    "course_name": "Matematica",
    "teacher_id": 3,
    "semester_id": 1,
    "class_id": 1,
    "dates": ["2023-09-27T17:04:49.9149Z"],
    "marks": [
        "mark_id" : 2,
        "course_id": 3,
        "mark_date": "2023-09-27T17:04:49.9149Z",
        "is_absent": false,
        "mark": 7,
        "student_id": 3,
        "createdAt":  "2023-09-27T17:04:49.9149Z",
        "updatedAt": null
    ]
}
```
</details>

`– POST /lesson` -  Creates a lesson for a course. Access limited to director and manager

<details>
           <summary>Request Body</summary>

```
{
    "name":"Matematica",
    "course_id":2,
    "start_hour":"9:00",
    "end_hour":"9:45",
    "week_day":"Tuesday",
    "classroom":"35"
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "id":3,
    "name":"Matematica",
    "course_id":2,
    "start_hour":"9:00",
    "end_hour":"9:45",
    "week_day":"Tuesday",
    "classroom":"35"
}
```
</details>

`– POST /mark` - Creates a mark or absence .

<details>
           <summary>Request Body</summary>

```
{
    "course_id":12,
    "mark_date":"2022-10-26T00:00:00Z",
    "is_absent":true,
    "mark":0,
    "student_id":7
}
```

</details>

<details>
           <summary>Response Body</summary>

```
{
    "id":1,
    "course_id":12,
    "mark_date":"2022-10-26T00:00:00Z",
    "is_absent":true,
    "mark":0,
    "student_id":7
}
```
</details>

## Deployment and Scaling:
Microservices can be deployed using Docker container. When it comes to containers orchestration, load balancing, 
Kubernetes cluster will be used for this.

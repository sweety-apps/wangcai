create table report_t (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    reportJsonData     text not null,
    type              text not null,
    subType           text not null,
    createTime        numeric default 0,
    status            integer default 0
);

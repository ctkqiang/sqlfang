-module(injector).
-export([inject/3, send_payload/3]).

%% inject/3 - 执行SQL注入测试
%% 参数：
%%   - Url：目标URL
%%   - Param：注入参数名
%%   - Dbms：数据库类型
inject(Url, Param, Dbms) ->
    Payloads = payloads:get_payloads(Dbms),
    lists:foreach(fun(P) -> send_payload(Url, Param, P) end, Payloads).

%% send_payload/3 - 发送单个注入payload
%% 参数：
%%   - Url：目标URL
%%   - Param：注入参数名
%%   - Payload：注入payload
send_payload(Url, Param, Payload) ->
    % 构造完整URL并进行URL编码
    FullUrl = Url ++ "?" ++ Param ++ "=" ++ uri_string:quote(Payload),
    % 创建新进程发送请求，避免阻塞主进程
    spawn(fun() ->
        try
            case httpc:request(get, {FullUrl, []}, [], []) of
                {ok, {{_, 200, _}, _, Body}} ->
                    io:format("注入成功！响应内容：~s~n", [Body]);
                {ok, {{_, Code, _}, _, _}} ->
                    io:format("请求返回状态码：~p~n", [Code]);
                {error, E1} ->
                    io:format("请求失败：~p~n", [E1])
            end
        catch
            E2:E3 ->
                io:format("执行错误：~p:~p~n", [E2, E3])
        end
    end).

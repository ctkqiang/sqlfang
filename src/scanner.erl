-module(scanner).
-export([start/0, scan/2, try_payload/3, analyze_response/1]).

%% start/0 - 初始化扫描器模块
%% 返回：ok
start() ->
    io:format("🔍 Scanner 模块已启动~n"),
    ok.

%% scan/2 - 执行SQL注入扫描
%% 参数：
%%   - Url：目标网站URL
%%   - Param：要测试的参数名
%% 返回：{ok, scanned} 或 {error, Reason}
scan(Url, Param) ->
    io:format("👀 正在扫描参数 ~s ...~n", [Param]),
    % 获取注入payload列表并逐一测试
    Payloads = payloads:get_payloads(unknown),
    lists:foreach(fun(P) -> try_payload(Url, Param, P) end, Payloads),
    {ok, scanned}.

%% try_payload/3 - 尝试单个注入payload
%% 参数：
%%   - Url：目标URL
%%   - Param：注入参数名
%%   - Payload：要测试的payload字符串
try_payload(Url, Param, Payload) when is_list(Payload) ->
    % URL编码payload，防止特殊字符导致请求错误
    EncPayloadBin = uri_string:quote(Payload),
    io:format("EncPayloadBin type: ~p value: ~p~n", [erlang:type(EncPayloadBin), EncPayloadBin]),
    EncPayload = binary_to_list(EncPayloadBin),
    % 构造完整的测试URL
    FullUrl = lists:flatten(io_lib:format("~s?~s=~s", [Url, Param, EncPayload])),
    io:format("💣 正在测试 payload: ~s~n", [Payload]),
    % 发送HTTP请求并分析响应
    case httpc:request(get, {FullUrl, []}, [], []) of
        {ok, {{_, 200, _}, _, Body}} ->
            analyze_response(Body);
        {ok, {{_, Code, _}, _, _}} ->
            io:format("⚠️ 返回状态码 ~p~n", [Code]);
        {error, Reason} ->
            io:format("❌ 请求失败: ~p~n", [Reason])
    end.

%% analyze_response/1 - 分析HTTP响应，检测数据库类型
%% 参数：
%%   - Body：HTTP响应体
analyze_response(Body) ->
    case detector:detect_dbms(Body) of
        "未知数据库" ->
            io:format("😶 未检测到数据库类型~n");
        DbType ->
            io:format("🧠 检测到数据库类型：~s~n", [DbType])
    end.

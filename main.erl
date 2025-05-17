%% -*- erlang -*-
%%! -sname sqlfang
%% @doc SQLFang - SQL注入检测工具
%% 用法： ./main.erl https://target.com/page.php id

-module(main).
-export([main/1]).

-mode(compile).

main([Url, Param]) ->
    io:format("~n🚀 SQLFang 启动中...~n"),
    io:format("🎯 目标地址: ~s~n", [Url]),
    io:format("🔑 注入参数: ~s~n", [Param]),

    % 启动 http 和 ssl 支持
    application:start(inets),
    application:start(ssl),

    % 载入模块路径（你要提前编译好 .beam 文件）
    code:add_path("ebin"),

    % 执行扫描流程
    case scanner:start() of
        ok ->
            case scanner:scan(Url, Param) of
                {error, Reason} ->
                    io:format("❌ 扫描失败: ~p~n", [Reason]);
                _ ->
                    ok
            end;
        error ->
            io:format("❌ 扫描器初始化失败，请确保依赖模块编译完成并可访问~n")
    end;

main(_) ->
    io:format("❌ 参数不足，请提供目标 URL 和参数名，例如： ./main.erl https://site.com/page.php id~n").

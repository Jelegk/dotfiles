-- various audio visualization

local opts = {
    mode = "force",
    -- off              disable visualization
    -- noalbumart       enable visualization when no albumart and no video
    -- novideo          enable visualization when no video
    -- force            always enable visualization

    name = "off",
    -- off
    -- showfreqs
    -- showcqt
    -- avectorscope
    -- showspectrum
    -- showcqtbar
    -- showwaves

    quality = "high",
    -- verylow
    -- low
    -- medium
    -- high
    -- veryhigh

    height = 9, -- 9 = 1080px
    -- [4 .. 12]

    forcewindow = true,
    -- true (yes)       always run visualizer regardless of force-window settings
    -- false (no)       does not run visualizer when force-window is no
}

-- key bindings
-- cycle visualizer
local cycle_key = "Alt+s"

if not (mp.get_property("options/lavfi-complex", "") == "") then
    return
end

local visualizer_name_list = {
    "off",
    "showfreqs",
    "showcqt",
    "showspectrum",
    "showwaves",
    "avectorscope",
}

local axis_0 = "image/png;base64," ..
"iVBORw0KGgoAAAANSUhEUgAAB4AAAAAgCAQAAABZEK0tAAAACXBIWXMAAA7EAAAOxAGVKw4bAAASO0lEQVR42u2de2wU1xXGV/IfSJEqVUJCQrIUISFFiiqhSFWkKFKFokpB1TqxHROT8ApueDgEE9u4MW4TSqFA" ..
"3TSUQmkSChRwII6BkAQCDSYlBtc1hiSA4/CyMcYGtsZvY3t3vXu719vVPjxzz71zd+wBvnOkdvHZ78w5v7mZmbt7Z9blgsFgMBgMBoPBYDAYDAaDwWAwGAwGg8FgMBgMBoPBYDAYDAaDwWCw+9HYBFbKboe8lE1A" ..
"HHHEEUccccQRRxxxxBFHHPEHNe4KBSJWijjiiCOOOOKII4444ogjjjjiD1icwWAwGAwGg8FgMBgM9hAYJsAwGAwGg8FgMBgMBnsozOVyR7zuQOSPdQeif0UcccQRRxxxxBFHHHHEEUcc8QciHn05KaPuwGDHYEfd" ..
"gUkZRgkQRxxxxBFHHHHEEUccccQRR/w+jhu9FQ6Hw+FwOBwOh8Ph8AfOx3Zz07LTXpmYzl89McuJOJ6e/czcCWkP7u4Gf/AHf/AHf/AHf/AHf/AHf/B/iPm73D99qaW2u7n7RqI/8lz4LWbxw1tVNjQh7dgH/Z6R" ..
"JdjBzmuXKxl7b42sdvqctrORCjqvTc1S3elx9V9vOXNy1+gcP3r+5K6Bu7y8YW/jqZO7PPU5S+Tyx/Fp9lysO/CLV1TqA3/wB3/wB3/wB3/wB3/wB3/wB/8x4e9yL37N+PlYP3o+/BazePVe+c089XL7D4n6qjJZ" ..
"dUlhrO7TLWo7wKj+gbvxkGbMv3sl8T3Ht8vlL8hLVPr6dq7Xqw/8wR/8wR/8wR/8wR/8wR/8wR/8k86f/89bK26eYazjSsXGsJ8ui90Bo+MVG7ua1HZAY1VoZj9Utacof8b8DSU15cGAmn5tcfnG/zaE2+tqUtsB" ..
"8fXv33T6w8EOxpprYt9xs46xgK9qT0Hes/M2rbr13cgA2SOfP+hnrLacZ68t72sNiYNvrbBWH/iDP/iDP/iDP/iDP/iDP/iDP/jbxD/8f3UVjF2v5q8ef9HlXpQbyjAcuxY7Gp8y8uV1878ZO7lLtsDNv+Ul/e5X" ..
"0b9cqlT9JGFypq+XscZTHM3bRaq7IFo/9z+/zZivPxrdsY7Xt35l5N8paV3XGavcLp8/4GMs0t+UrFvf8mESWcKgVh/4gz/4gz/4gz/4gz/4gz/4gz/428Q/vsC1xQFf9b5JGXcvf3/UqIE1bw57az5yuff/uadl" ..
"eZ5sefzzh8ZTsX+ZPmfvO5MzVRCWv8tXhz8xi6O5+pXeDqjaw1hvazTaFNqtjV/Hvn/Xho4ruUut7QCXO/vV4DBja95Ur0+Ff+Fy8Ad/8Ad/8Ad/8Ad/8Ad/8Ad/8FfgHy2wt7Wugs+d284aNxCJ36xTbb+7mbGj" ..
"76uq4p2vYb9U6XIf3sq/LH/qZfUdwOuvq/juM89F/nnD3ndi6gvt1C+06ovfAaGMN9Q6Bn/wB3/wB3/wB3/wB3/wB3/wB3/b+UcLjFjbOeMGRPFHnpu7yBzKPQ9jkduSH39xweKcJTlLFiz+Sbas3uVe9jrf8soC" ..
"rh8eZOzETpXtx9cfvgm7IOb76/6Y+sw8Je3Jl+R3AF/TfrpMXq/LX5yf5k/VR/FX6c8K/4npOUvi61XjT+l1+Yvz0/yp+ij+Kv1Z4f/oC4tyfz7POn9Kr8tfnJ/mT9VH8Vfpz9rxR+0EMPr4Q5+g9I4/Ipc5/oid" ..
"Pv7I9wf+9yf/1MxXc/kCQav8Rfpk8DfPL8dfVJ8Mf9n+MP7vv/HPr29/Nts6f0qfjOt/8/xy1/+i+mSu/2X7szb+017JWWK+qJYe/2K9/vgX5ZcZ/+L66PEv35/Djj/RAgfaG6u6Gs0/gTCPry4aaOdtNf/70ReM" ..
"NtJ/i7GyUv6qII/ffv1/Cxbly+ld7otH+Kr469Xcvd2M9d+OXSFP60fqv8vVzdWe+oCXsYA3+hV5/23GPvyjGaKfZB/a0nTK211/VH4H3DkfGiQ75PU6/On8Yv4y9Yn4S/dnkX9KWs1HXMEXUZj9epmIv4xehz+d" ..
"X8xfpj4Rf+n+LPJPzfz+GOfLWOfVuYvU+cvodfjT+cX8ZeoT8ZfuzyL/sJcU+geHB+ctVucvo9c7/lP5qeM/XZ/4+C/Zn0X+0+cEfGEf9n77qTp/Gb0Ofzq/mL9MfSL+0v1pjP8JabUf8wsvFvzkL1bGP6XXHf/i" ..
"/PT4p+qjxr9Ufxb5tzdE9i/3jBxV/jJ6Hf50fjF/mfpE/KX7szz+95R6e3jBd86b/cCLePzTer3xT+Wnxj9dn3j8S/Znmf9rr/e08Pz9HmvnX1qvx5/KT/Gn6xPzl+xP6/pHbQI8+vpHYgLM12i/t4axugMu94aS" ..
"tm8W5cY3wON/X8fYuYOJF6D3PN7ek7svf8VYTbnRRtrOMla1m796Zm74t564+e+FPwWg9VOz/AOJj7revEp++4lr0J98qb2BsfYfIv/mzzerrTBDdO4gX/3OmPwEeELaUGeowt/K63X40/nF/Gm9mL9Kf1b4f7mN" ..
"sdvnj29vrmbBq1+r85fR6/Cn84v503oxf5X+rPCv2MhYS+2xbRePDA92XlPnL6PX4U/nF/On9WL+Kv1Z4R8m2nmNb9Xst/FE/GX0Ovzp/GL+tF7MX6U/K/yfmcsfqXG58nLlD8e3rlbnL6PX4U/nF/On9WL+Kv1Z" ..
"G/+pmfwpop3Xaj769tDqIvXxT+v1xj+Vnxr/lJ4a//L9WeHf3jDQwffu5cq+NsaM17mI+MvodfjT+cX8ab2Yv0p/Vvgvez043Nd6uqzhy4DPU69+/JHR6/Cn84v503oxf5X+rPBPSeu+4R+s3ne6zD8w0G5856yI" ..
"v4xehz+dX8yf1ov5q/Rn9fpHbQI8+vpHegLscucuTQnN7fnTvmK/5o7G85alpI2+AA3jaP5PwBt9eHfUa/kK8JsRNFOypmbxXRJ5DDetP7QltLsG+ArysPe2hi45z8hvP3EHuNzb1jLm7Y386/SHoX/1zJgfjU9M" ..
"L3931sLI7nq7aGK6ygT4c75O3v/MXHm9Dn86v5g/rRfzV+tPnX/bue7m8OdNjaeGBxO/+aH5y+h1+NP5xfxpvZi/Wn/q/KdmrS0Ovzr/GWPGP4Mu4i+j1+FP5xfzp/Vi/mr9qfPnzu+84ZdXchPgeP4yeh3+dH4x" ..
"f1ov5q/Wnzp/PsGjfjJCxF9Gr8Ofzi/mT+vF/NX6szL++c+CfHPI+MgmM/5pvd74p/JT45/SU+NfpT91/sX5kUl1b2t3szp/Gb0Ofzq/mD+tF/NX60+d/4kdjIUnQ98eYsx4kbuIv4xehz+dX8yf1ov5q/Wnzn/m" ..
"Lxk7/eFIH+WM7Vinyl9Gr8Ofzi/mT+vF/NX6s3b9ozYBHn39Q0yAfzabPxb79vmi/Ih7vo89QEfjK94YfaftuU+CgfC0k4My+hJ8xnz/YGjG31BakprJPzFYnsefJRbJT+mfnce/+G89G/ls7cmX6vYzFgwW54eH" ..
"Ar39+P7eWlGx0VPPF0xE4o/N7LvFv9bfUxr+z6cg785Fxm7GXWKJJnjTsgN+xg5uKsovzt/2+4tHWHD0CnSRXo8/nT+Rf96yWP6UnuKv2p8q/6deDt/dMTG9+8Y9jyz/aHe0Xo8/nV/Mn9JT/FX7szb+p8/ZvGqw" ..
"o7NRnT+tT8b4F+WXGf/mernxL9+fOv+nZ/v6Oq9+9Q+zCR7Fn9Lr8qfyU/zFepq/Wn+q/PkEr/1Sc03LmSPvGU8yxPxpvR5/Or+YP6Wn+Kv2p8p/UoZ/sKvx6dkbSqbPkT//RunRej3+dH4xf0pP8Vftz9rxn196" ..
"m91XJ3P8F+mTcfwX5Zc5/pvr5Y7/8v2p8t+6mrHPt05Ie2LWnfP3/qvOn9br8afzi/lTeoq/an+q/GctDH8r63Lvfcf4m0oxf1qvx5/OL+ZP6Sn+qv1ZPf6Yu9zxx3QCnLuUPzR6tEVShOLRdeMsGEicmTediszl" ..
"d65nrLTEaDOfbuFFcbm3h/9oMbfIwUKsX1v8f2XI+CdtM+aH73fkFl7wTG0/vv6IBXwlhdH3FC739ob/7usN5w8Gd/9BboI4a+Fofo1f/zhddoKqy5+egIr5i/WJ/J+dF+Vf+7Fkf0ngPymj5Qxjxz6Q4990amJ6" ..
"4mWKmT45/M3zy/E308vyF/anzX/Lav63oU6jB03I8Bfpk8FflF+Gv7lejj/Rnyb/H44Hg0X5lduNJ3g0f7Fen784P81fpJfhT/anxf+JWSMLxgYHOxJ/rEGOP6XX5U/lp/iL9TR/if60+OcuDV0sXeCXcEG/0ZM9" ..
"Kf6UXpc/lZ/iL9bT/CX6S8L51+Wu/djq8UesT8751zy/3PnXTC97/hX2p8mf32Tm7Q0O+/tXvGGFv1ivz1+cn+Yv0svwJ/vT4p+S1tfq69+/6eRufpc9fxKyGn9Kr8ufyk/xF+tp/hL9JeX4Y+ayxx/TCfC07PAt" ..
"zGY7ID7e70m8zb/pdOwE9I+/Nt5QacmdC1EQnVc/+lOkRLF+1kK+tG3k8rKLD+/JmXevhHfJ8ODx7TLbT+wvGLznaTr12uuJlxEXDocfZcOt7WxkWSM9wZuW3R3NH/T3tzfsKVWZoOryl5kAi/iL9Yn8J2Uk8lft" ..
"zwr/adn8AfDG9wmM5l9WOvo9Ir0+f1F+Gf7mejn+Kv1Z4f/YzENbQtOMQHP16AOLDH+xXp+/KL8Mf3O9HH+V/lT5/6aQBS8cdrnNJngUf1qvx5/KT/EX62n+qv2pj/+y0tKSiekpafVfMBb74C7Z8U/pdce/OD89" ..
"/kV6mfGv1p8q/02r+F+aq/f+6e6lYDD26aFy/Gm9Hn8qP8VfrKf5q/Zn7fqHP6rGeIGvzPFfrE/G9Y95frnrHzO97PWPfH+q/FMz275hbLAj4AsGyt9V50/r9fhT+Sn+Yj3NX7U/9fFflD/QMfLX0DVWzT718U/p" ..
"dce/OD89/kV6mfGv1p/V44+Zyx5/TCfAuv7NoeBw+AHYfAnygsXm73xs5sqCzauK8uO/xpfX626f8tTMksLNqwryjB6QT00wKdfVJyO/MX/n9GfGf/ZCftdBVZnVvLr6ZOU34++U/kTjn/snf9F7Wp+uXje/aPw7" ..
"oT9j/vyjjb62riZ+kmk7a/yMA5Hr6pOX35i/c/qjxn9BHmOf/dV6fl29bn5q/I93f8b8V7zBHzLHX5UUMnZyl2pWXX3y8hvzd05/ovFflK93htHVJyO/aPw7oT9j/l+8z9i2tSlpU7MaqwL+KVmqWXX1yctvzN85" ..
"/ZmP/ylZ61fmLj25m2/JSmZdfXLym49/Z/RHnX9tcf0U+zcxtvEt/up6dcCnfgEy3no5fxAmwPdnf+uKfb1BP/9s76mX/75u7PVOr8/u/qK+Yx1j5p/x2q93en329Hf5q86r3PlPvd08o35809U7vT67+5ucGbnX" ..
"74M1jO3aMNZ6p9dnd39TsoaHum/wVzlLGPvXP8Za7/T67O4v7GcPitZ32K93en329dfwZdCfOvIAoyN/Y8xskbF9eqfXZ3d/EV/zZsDXdV30qDl79U6vz+7+bPJknAAG2oe6jm///hhjdfvvPz3lxfkXDtcfZay7" ..
"pf5obYX02vKk6Z1en739PTuP37PQ1VR/tP6o5yJjks92S5re6fXZ3Z/L3VzdXP351oObqvcNdfv6jX/mwU690+uzu7+wn9jZfinysInx0Du9Pvv662rsaancvn9TzT5vz1D3tOyx1ju9Prv7c7n5mb3hn59u6bjC" ..
"TJcY26l3en1298f9nqf7+njqnV6fff2Vv8t/4urEzu8+8/V7e1Izx1rv9Prs7u/xF2srTuy4+q9gYKizcPnY651en9392ezJSLJ+5VAXX4DdenZq1v2oF3vl9uhN1v7+2Id1j43e6fXZ29/shfF3RryQM7Z6p9dn" ..
"d38ud/W+yL0Zva3rV4693un12d0f9x+n8x+zZ+yeZ1LGeOidXp+d/ZVv9PaE9293i9kdtnbqnV6f3f3x59u3/Cf84JQv3h8PvdPrs7s/l/uR5/pu6Sxu19U7vT57+6v9OHyG6WuL/tTLWOqdXp+9/WXk8AfMMea5" ..
"+ItXxkPv9Prs7s9mT9YpIHepTvvjrYfD4Waempm7tDj/+QVWl7fo6p1en939wcfXH3luweKifLMfmbFf7/T67O6Pe/ary/MefWH89E6vz+7+4OPpU7Pyls38pfXzi67e6fXZ29/kzOV5OrMLXb3T67O7P1sdBxc4" ..
"HA6Hw+FwOBwOhz8UDgRwOBwOh8PhcDgcDn8oHAjgcDgcDofD4XA4HP4w+P8AQEuXMXpD8/kAAAAASUVORK5CYII="


local options = require 'mp.options'
local msg     = require 'mp.msg'

options.read_options(opts)
opts.height = math.min(12, math.max(4, opts.height))
opts.height = math.floor(opts.height)

if not opts.forcewindow and mp.get_property('force-window') == "no" then
    return
end

local function get_visualizer(name, quality)
    local w, h, fps

    if quality == "verylow" then
        w = 640
        fps = 30
    elseif quality == "low" then
        w = 960
        fps = 30
    elseif quality == "medium" then
        w = 1280
        fps = 60
    elseif quality == "high" then
        w = 1920
        fps = 60
    elseif quality == "veryhigh" then
        w = 2560
        fps = 60
    else
        msg.log("error", "invalid quality")
        return ""
    end

    h = w * opts.height / 16

    if name == "showcqt" then
        local count = math.ceil(w * 180 / 1920 / fps)

        return "[aid1] asplit [ao]," ..
            "aformat            = channel_layouts = stereo," ..
            "showcqt            =" ..
                "fps            =" .. fps .. ":" ..
                "size           =" .. w .. "x" .. h .. ":" ..
                "count          =" .. count .. ":" ..
                "csp            = bt709:" ..
                "bar_h          =" .. h * 0.3 .. ":" ..
                "bar_g          = 2:" ..
                "sono_g         = 4:" ..
                "bar_v          = 9:" ..
                "sono_v         = 17:" ..
                "axisfile       = data\\\\:'" .. axis_0 .. "':" ..
                "font           = 'Nimbus Mono L,Courier New,mono|bold':" ..
                "tc             = 0.33:" ..
                "attack         = 0.033:" ..
                "tlength        = 'st(0,0.17); 384*tc / (384 / ld(0) + tc*f /(1-ld(0))) + 384*tc / (tc*f / ld(0) + 384 /(1-ld(0)))':" ..
                "cscheme        = '0.5|0|1|0|1|0.5'," ..
            "format             = yuv420p [vo]"

    elseif name == "showfreqs" then
        return "[aid1] asplit [ao]," ..
            "showfreqs          =" ..
                "size           =" .. w .. "x" .. h .. ":" ..
                "r              =" .. fps / 2 .. ":" ..
                "mode           = line" .. ":" ..
                "win_size       = 4096" .. ":" ..
                "win_func       = blackman" .. ":" ..
                "averaging      = 3" .. ":" ..
                "colors         = purple|blue|0x00CC55|white," ..
            "format             = rgb0 [vo]"

    elseif name == "avectorscope" then
        return "[aid1] asplit [ao]," ..
            "aformat            =" ..
                "sample_rates   = 192000," ..
            "avectorscope       =" ..
                "size           =" .. w .. "x" .. h .. ":" ..
                "r              =" .. fps .. ":" ..
                "draw           = aaline" .. "," ..
            "format             = rgb0 [vo]"

    elseif name == "showspectrum" then
        return "[aid1] asplit [ao]," ..
            "showspectrum       =" ..
                "size           =" .. w .. "x" .. h .. ":" ..
                "stop           = 6000" .. ":" .. -- top frequency limit (bottom is 0Hz)
                "color          = fruit" .. ":" .. -- "fire" (black & yellow), "green" (mint), "fiery" (burned red)
                "win_func       = blackman [vo]"

    elseif name == "showwaves" then
        return "[aid1] asplit [ao]," ..
            "showwaves          =" ..
                "size           =" .. w .. "x" .. h .. ":" ..
                "r              =" .. fps / 2 .. ":" ..
                "mode           = cline" .. ":" ..
                "colors         = purple|blue|0x00CC55|white," ..
            "format             = rgb0 [vo]"
    
    elseif name == "off" then
        local hasvideo = false
        for id, track in ipairs(mp.get_property_native("track-list")) do
            if track.type == "video" then
                hasvideo = true
                break
            end
        end
        if hasvideo then
            return "[aid1] asetpts=PTS [ao]; [vid1] setpts=PTS [vo]"
        else
            return "[aid1] asplit [ao]," ..
                "showfreqs          =" ..
                    "size           =" .. w .. "x" .. h .. ":" ..
                    "r              =" .. fps / 2 .. ":" ..
                    "mode           = line" .. ":" ..
                    "win_size       = 128" .. ":" ..
                    "averaging      = 3" .. ":" ..
                    "colors         = purple|blue|0x00CC55|white," ..
                "format             = rgb0 [vo]"
        end
    end

    msg.log("error", "invalid visualizer name")
    return ""
end

local function select_visualizer(vtrack, atrack)
    if atrack == nil or opts.mode == "off" then
        return ""
    elseif opts.mode == "force" then
        return get_visualizer(opts.name, opts.quality)
    elseif opts.mode == "noalbumart" then
        if vtrack == nil then
            return get_visualizer(opts.name, opts.quality)
        end
        return ""
    elseif opts.mode == "novideo" then
        if vtrack == nil or vtrack.albumart then
            return get_visualizer(opts.name, opts.quality)
        end
        return ""
    end

    msg.log("error", "invalid mode")
    return ""
end

local function visualizer_hook()
    local count = mp.get_property_number("track-list/count", -1)
    if count <= 0 then
        return
    end

    local atrack = mp.get_property_native("current-tracks/audio")
    local vtrack = mp.get_property_native("current-tracks/video")

    --no tracks selected (yet)
    if atrack == nil and vtrack == nil then
        for id, track in ipairs(mp.get_property_native("track-list")) do
            if track.type == "video" and (vtrack == nil or vtrack.albumart == true) and mp.get_property("vid") ~= "no" then
                vtrack = track
            elseif track.type == "audio" then
                atrack = track
            end
        end
    end

    local lavfi = select_visualizer(vtrack, atrack)
    --prevent endless loop
    if lavfi ~= "" and lavfi ~= mp.get_property("lavfi-complex", "") then
        mp.set_property("file-local-options/lavfi-complex", lavfi)
    end
end

mp.add_hook("on_preloaded", 50, visualizer_hook)
mp.observe_property("current-tracks/audio", "native", visualizer_hook)
mp.observe_property("current-tracks/video", "native", visualizer_hook)

local function cycle_visualizer()
    local i, index = 1
    for i = 1, #visualizer_name_list do
        if (visualizer_name_list[i] == opts.name) then
            index = i + 1
            if index > #visualizer_name_list then
                index = 1
            end
            break
        end
    end
    opts.name = visualizer_name_list[index]
    visualizer_hook()
end

mp.add_key_binding(cycle_key, "cycle-visualizer", cycle_visualizer)
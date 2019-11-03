﻿Shader "Image Effects/BoxBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
				float xd = 1 / _ScreenParams.x;
				float yd = 1 / _ScreenParams.y;

				fixed4 col = (
					tex2D(_MainTex, float2(i.uv.x - xd, i.uv.y - yd)) +
					tex2D(_MainTex, float2(i.uv.x - xd, i.uv.y)) +
					tex2D(_MainTex, float2(i.uv.x - xd, i.uv.y + yd)) +
					tex2D(_MainTex, float2(i.uv.x, i.uv.y - yd)) +
					tex2D(_MainTex, float2(i.uv.x, i.uv.y)) +
					tex2D(_MainTex, float2(i.uv.x, i.uv.y + yd)) +
					tex2D(_MainTex, float2(i.uv.x + xd, i.uv.y - yd)) +
					tex2D(_MainTex, float2(i.uv.x + xd, i.uv.y)) +
					tex2D(_MainTex, float2(i.uv.x + xd, i.uv.y + yd))
					) / 9;
                return col;
            }
            ENDCG
        }
    }
}
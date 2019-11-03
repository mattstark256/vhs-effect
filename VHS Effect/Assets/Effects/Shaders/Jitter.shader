Shader "Image Effects/Jitter"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_JitterTex("Jitter Texture", 2D) = "white" {}

		_Speed("Speed", Float) = 1
		_ScaleV("Vertical Scale", Float) = 1
		_ScaleH("Horizontal Scale", Float) = 1
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
			sampler2D _JitterTex;
			float _Speed;
			float _ScaleV;
			float _ScaleH;

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col2 = tex2D(_JitterTex, float2(_Time[1] * _Speed, i.uv.y * _ScaleV));
                fixed4 col = tex2D(_MainTex, i.uv + float2(col2.r * _ScaleH, 0));
                return col;
            }
            ENDCG
        }
    }
}

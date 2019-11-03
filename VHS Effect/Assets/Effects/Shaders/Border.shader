Shader "Image Effects/Border"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_CurveRadius("Curve Radius", Float) = 0.1
		_FadeDistance("Fade Distance", Float) = 0.1
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
			float _CurveRadius;
			float _FadeDistance;

            fixed4 frag (v2f i) : SV_Target
            {
				float aspect = _ScreenParams.x / _ScreenParams.y;
				float2 uv2 = float2(i.uv.x * aspect, i.uv.y);
				float2 clampedUV = float2(clamp(uv2.x, _CurveRadius, aspect - _CurveRadius), clamp(uv2.y, _CurveRadius, 1 - _CurveRadius));
				float2 v = uv2 - clampedUV;
				float borderDistance = (v.x == 0 || v.y == 0) ? _CurveRadius - max(abs(v.x), abs(v.y)) : _CurveRadius - distance(clampedUV, uv2);
				if (borderDistance < 0) return fixed4(0, 0, 0, 1);
				fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb *= clamp((borderDistance / _FadeDistance), 0, 1);
				return col;
            }
            ENDCG
        }
    }
}

Shader "Image Effects/VHS"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

		_YCurve("Y Curve", Vector) = (0.8, 0.6, 0.4, 0.2)
		_YLength("Y Length", Float) = 0.1
		_YScale("Y Scale", Float) = 0.2
		_IQCurve("IQ Curve", Vector) = (0.8, 0.6, 0.4, 0.2)
		_IQLength("IQ Length", Float) = 0.1
		_IQScale("IQ Scale", Float) = 0.2
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
			float4 _YCurve;
			float _YLength;
			float _YScale;
			float4 _IQCurve;
			float _IQLength;
			float _IQScale;

			float getCurveValue(float4 curve, float f)
			{
				int section = (int)(f * 5);

				float lower = 1;
				float higher = 0;

				switch (section) {
				case 0: higher = curve[0]; break;
				case 1: lower = curve[0]; higher = curve[1]; break;
				case 2: lower = curve[1]; higher = curve[2]; break;
				case 3: lower = curve[2]; higher = curve[3]; break;
				case 4: lower = curve[3]; break;
				}

				return lerp(lower, higher, f - (float)section / 5);
			}

			float getYAtUV(float2 uv)
			{
				fixed4 c = tex2D(_MainTex, uv);
				return c.r * 0.299 + c.g * 0.587 + c.b * 0.114 - 0.5;
			}

			float2 getIQAtUV(float2 uv)
			{
				fixed4 c = tex2D(_MainTex, uv);
				return float2(
					c.r * 0.5959 + c.g * -0.2746 + c.b * -0.3213,
					c.r * 0.2115 + c.g * -0.5227 + c.b * 0.3112
					);
			}

			float3 yiQToRGB(float3 yiq)
			{
				return float3(
					yiq.x * 1 + yiq.y * 0.956 + yiq.z * 0.619,
					yiq.x * 1 + yiq.y * -0.272 + yiq.z * -0.647,
					yiq.x * 1 + yiq.y * -1.106 + yiq.z * 1.703
					);
			}

            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = tex2D(_MainTex, i.uv);
                // just invert the colors
                //col.rgb = 1 - col.rgb;


				float y = 0;
				float2 iq = float2(0, 0);
				for (int j = 0; j < 20; j++)
				{
					float f = (float)j / 20;
					y += getYAtUV(i.uv + float2(f * _YLength, 0)) * getCurveValue(_YCurve, f);
					iq += getIQAtUV(i.uv + float2(f * _IQLength, 0)) * getCurveValue(_IQCurve, f);
				}
				y *= _YScale;
				iq *= _IQScale;
				y += 0.5f;

				fixed4 col = fixed4(yiQToRGB(float3(y, iq)), 1);
                return col;
            }
            ENDCG
        }
    }
}

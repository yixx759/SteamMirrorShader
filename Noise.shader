Shader "Unlit/Noise"
{
    Properties
    {
        _scale ("scale" ,Float) =0.6
        _offsetx ("offx" ,Float) =0.6
        _offsety ("offy" ,Float) =0.6
        _frequency ("frq" ,Float) =0.6
        _Amp ("amp" ,Float) =0.6
        _lacunarity ("luc" ,Float) =0.6
        _gain ("gain" ,Float) =0.6
        _power ("power" ,Float) =0.6
        _octaves ("octave" ,int) =1
       
        
        
        
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Lighting Off
        Blend One Zero

        Pass
        {
            CGPROGRAM
            #include "UnityCustomRenderTexture.cginc"
            #pragma vertex InitCustomRenderTextureVertexShader
            
            #pragma fragment frag
            #pragma target 3.0
            // make fog work
            #include "UnityCG.cginc"
            

            
            float2 quad(float2 t)
            {
                
                return ( 810000)-60*(t*t*t)+30*(t*t);
                
            }
            

            float2 random (float2 uv)
            {
                
                
                 // p = p + 0.02;
                 //  float x = dot(p, float2(123.4, 234.5));
                 //  float y = dot(p, float2(234.5, 345.6));
                 //  float2 gradient = float2(x, y);
                 //  gradient = sin(gradient);
                 //  gradient = gradient * 43758.5453;
                 //
                 //  // part 4.5 - update noise function with time
                 //  // gradient = sin(gradient);
                 //  return gradient;
                
                // return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
                float x = dot(uv, float2(123.4, 234.5));
                float y = dot(uv, float2(234.5, 345.6));
                float2 gradient = float2(x,y);
                
                return sin(sin(gradient* 43758.5453)) ;
            }


            
            float _scale;
            float _offsetx;
            float _offsety, _Amp, _lacunarity,_gain, _power ;
            int _octaves;
            float _frequency;



            float calc(float2 uv)
            {
                float value = 0;
                uv.xy  = uv.xy * _scale+float2(_offsetx, _offsety) ;
                for(int i =0; i <_octaves; i++)
                {
                    float2 uvf = floor(uv.xy*_frequency);
                float2 uvff = frac(uv.xy*_frequency);
                float2 ay= uvff * uvff * uvff * ( uvff * ( uvff * 6.0 - 15.0 ) + 10.0 );

                float2 a = uvf.xy + float2(0.0,0.0);
                float2 b = uvf.xy + float2(1.0,0.0);
                float2 c = uvf.xy + float2(0.0,1.0);
                float2 d = uvf.xy + float2(1.0,1.0);

                a = random(a);
                b = random(b);
                c = random(c);
                d = random(d);
                

                

                
                

                float A = dot(a , uvff - float2(0.0,0.0));
                float B = dot(b , uvff - float2(1.0,0.0));
                float C = dot(c , uvff - float2(0.0,1.0));
                float D = dot(d , uvff - float2(1.0,1.0));


                float noise = lerp(lerp(A,B,ay.x),lerp(C,D,ay.x),ay.y);
                value +=noise + _Amp;
                    _frequency *= _lacunarity;
                    _Amp *= _gain;


                    
                }
                
                
               value = clamp( value, -1.0, 1.0 );
                return pow(value * 0.5 + 0.5,_power);
                

                
                
            }


            float4 frag(v2f_init_customrendertexture IN) : COLOR
            {


                return calc(IN.texcoord.xy);
                
            }
            
            ENDCG
        }
    }
}

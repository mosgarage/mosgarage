const express=require('express');const Docker=require('dockerode');const cors=require('cors');
const app=express();const docker=new Docker({socketPath:'/var/run/docker.sock'});
app.use(cors());app.use(express.json());
app.post('/start/:name',async(req,res)=>{try{await docker.getContainer(req.params.name).start();res.json({success:true})}catch(e){res.status(500).json({success:false,error:e.message})}});
app.post('/stop/:name',async(req,res)=>{try{await docker.getContainer(req.params.name).stop();res.json({success:true})}catch(e){res.status(500).json({success:false,error:e.message})}});
app.get('/status',async(req,res)=>{try{const containers=await docker.listContainers({all:true});const s={};containers.forEach(c=>s[c.Names[0].replace('/','')]=c.State);res.json(s)}catch(e){res.status(500).json({error:e.message})}});
app.get('/onboarding',(req,res)=>res.json({steps:['Start core: docker compose up -d','Open https://localhost','Start modules: docker compose up -d <service>']}));
app.listen(3000,()=>console.log('api'));
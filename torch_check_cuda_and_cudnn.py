import torch

print("torch version: ", torch.__version__, 
      "\ncuda version: ", torch.version.cuda,
      "\ncudnn version: ", torch.backends.cudnn.version(), 
      "\ndevice name: ", torch.cuda.get_device_name(0)
      )

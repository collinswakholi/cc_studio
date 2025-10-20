# 🚀 Publishing Docker Image via GitHub Actions (No Admin Required!)

## Why This Approach?

Since you don't have admin privileges to run Docker Desktop, we'll use **GitHub Actions** to build and push your Docker image automatically. GitHub provides free Docker build servers!

---

## 📋 Step-by-Step Setup

### Step 1: Get Docker Hub Access Token

1. Go to [Docker Hub](https://hub.docker.com/)
2. Click your profile (top right) → **Account Settings**
3. Go to **Security** → **Access Tokens**
4. Click **New Access Token**
   - Description: `GitHub Actions`
   - Access permissions: `Read, Write, Delete`
5. Click **Generate**
6. **Copy the token** (you won't see it again!)

---

### Step 2: Add Token to GitHub Repository

1. Go to your GitHub repository
2. Click **Settings** (repository settings, not account)
3. Go to **Secrets and variables** → **Actions**
4. Click **New repository secret**
5. Add:
   - **Name**: `DOCKER_HUB_TOKEN`
   - **Value**: [Paste the token from Step 1]
6. Click **Add secret**

---

### Step 3: Push Code to GitHub

If you haven't already, initialize and push your repository:

```powershell
# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Add Docker configuration"

# Add your GitHub repository as remote
git remote add origin https://github.com/collins137/color-correction-studio.git

# Push to GitHub
git push -u origin main
```

---

### Step 4: Trigger the Build

The Docker image will build automatically when you:

**Option A: Push to main branch**
```powershell
git add .
git commit -m "Update application"
git push
```

**Option B: Manual trigger**
1. Go to your GitHub repository
2. Click **Actions** tab
3. Click **Docker Build and Push** workflow
4. Click **Run workflow** → **Run workflow**

---

## 🎯 What Happens Next

GitHub Actions will:
1. ✅ Check out your code
2. ✅ Set up Docker Buildx
3. ✅ Login to Docker Hub (using your token)
4. ✅ Build your Docker image (~10-15 minutes)
5. ✅ Push to `collins137/color-correction-studio:latest`

---

## 📊 Monitor Progress

1. Go to **Actions** tab in your GitHub repository
2. Click on the running workflow
3. Watch the live build logs
4. When complete, you'll see ✅ green checkmark

---

## 🎉 After Build Completes

Your image will be available at:
- **Docker Hub**: https://hub.docker.com/r/collins137/color-correction-studio
- **Pull command**: `docker pull collins137/color-correction-studio:latest`

Anyone can now run your app:
```bash
docker run -d -p 5000:5000 collins137/color-correction-studio:latest
```

Or use the provided scripts:
```powershell
.\run-docker.bat  # Windows
./run-docker.sh   # Linux/macOS
```

---

## 🔄 Alternative: Use Codespaces (Free Docker!)

GitHub Codespaces includes Docker pre-installed:

1. Go to your GitHub repository
2. Click **Code** → **Codespaces** → **Create codespace on main**
3. Wait for environment to load
4. In the terminal, run:

```bash
# Login to Docker Hub
docker login -u collins137

# Build
docker build -t color-correction-studio:latest .

# Tag
docker tag color-correction-studio:latest collins137/color-correction-studio:latest

# Push
docker push collins137/color-correction-studio:latest
```

Free tier includes 120 core-hours/month!

---

## 🔄 Alternative: Use Play with Docker (Online)

1. Go to [Play with Docker](https://labs.play-with-docker.com/)
2. Click **Login** (use Docker Hub credentials)
3. Click **Start**
4. Click **+ ADD NEW INSTANCE**
5. In the terminal:

```bash
# Clone your repository
git clone https://github.com/collins137/color-correction-studio.git
cd color-correction-studio

# Login
docker login -u collins137

# Build
docker build -t collins137/color-correction-studio:latest .

# Push
docker push collins137/color-correction-studio:latest
```

Sessions last 4 hours - enough to build and push!

---

## 🔄 Alternative: Use Cloud Build Services

### Google Cloud Build (90 min/day free)
```bash
gcloud builds submit --tag gcr.io/[PROJECT-ID]/color-correction-studio
```

### Azure Container Registry
```bash
az acr build --registry [REGISTRY] --image color-correction-studio:latest .
```

---

## 📝 Summary: Your Best Options

| Method | Free Tier | Best For |
|--------|-----------|----------|
| **GitHub Actions** ⭐ | Unlimited public repos | Automated builds |
| **GitHub Codespaces** | 120 hours/month | One-time builds |
| **Play with Docker** | 4-hour sessions | Quick testing |
| **Local Docker** | N/A | Requires admin |

---

## ✅ Recommended: GitHub Actions

**Pros:**
- ✅ No admin privileges needed
- ✅ Automated on every push
- ✅ Free for public repositories
- ✅ Professional CI/CD setup
- ✅ Works from any computer

**Setup time:** ~5 minutes

---

## 🆘 Need Help?

### Check GitHub Actions logs:
1. Go to repository → **Actions**
2. Click on failed workflow
3. Click on failed step to see error

### Common issues:

**Build fails:**
- Check Dockerfile syntax
- Verify all files are committed

**Push fails:**
- Check Docker Hub token is correct
- Verify token has write permissions

**Token not working:**
- Regenerate token in Docker Hub
- Update `DOCKER_HUB_TOKEN` secret in GitHub

---

## 🎯 Quick Start Checklist

- [ ] Get Docker Hub access token
- [ ] Add token to GitHub secrets as `DOCKER_HUB_TOKEN`
- [ ] Push code to GitHub
- [ ] Go to Actions tab
- [ ] Click "Run workflow"
- [ ] Wait 10-15 minutes
- [ ] Check Docker Hub for your image!

---

**Ready?** Start with GitHub Actions - it's the easiest way! 🚀

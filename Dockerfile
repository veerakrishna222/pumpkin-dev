# -------------------------------------------------------
# Base image for building the Next.js application
# -------------------------------------------------------
FROM node:20 AS builder

WORKDIR /app

# Copy only package files first for efficient caching
COPY package*.json ./

# Install dependencies (preferably clean install)
RUN npm install

# Copy all source files
COPY . .

# Build the Next.js app (this creates .next folder)
RUN npm run build

# -------------------------------------------------------
# Production image
# -------------------------------------------------------
FROM node:20 AS runner

WORKDIR /app

# If you need FFmpeg (optional)
# RUN apt-get update && apt-get install -y ffmpeg && apt-get clean

ENV NODE_ENV=production

# Copy built assets from builder stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

# Next.js runs on port 3000 by default
EXPOSE 3000



# ---------- Build Stage ----------
FROM node:18-alpine AS build

# Set working directory
WORKDIR /usr/src/app

# Copy dependency files first (for caching)
COPY package*.json ./

# Install dependencies
RUN npm ci --legacy-peer-deps

# Copy the rest of the project
COPY . .

# Build the production app hdb
RUN npm run build


# ---------- Production Stage ----------
FROM node:18-alpine

# Install 'serve' globally to serve static files
RUN npm install -g serve

# Set working directory
WORKDIR /app

# Copy only the build output from the previous stage
COPY --from=build /usr/src/app/dist ./dist

# Expose the app port
EXPOSE 8080

# Command to serve the built app
CMD ["serve", "-s", "dist", "-l", "8081"]

# Stage 1: Build the React app
FROM node:16-slim AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies (consider using --production for only production dependencies)
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Serve the React app with a lightweight web server
FROM node:16-alpine AS production

# Set the working directory
WORKDIR /app

# Copy the build output from the previous stage
COPY --from=build /app/build ./build

# Install a simple HTTP server
RUN npm install -g serve

# Expose port 3000 (or the port your app is configured to listen on)
EXPOSE 3000

# Start the HTTP server to serve the built files
CMD ["serve", "-s", "build"]

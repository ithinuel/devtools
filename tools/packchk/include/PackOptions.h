/*
 * Copyright (c) 2020-2021 Arm Limited. All rights reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef PACKOPTIONS_H
#define PACKOPTIONS_H

#include <string>
#include <set>


class CPackOptions {
public:
  CPackOptions();
  ~CPackOptions();


  bool SetWarnLevel(const uint32_t warnLevel);
  bool SetLogFile(const std::string& m_logFile);
  bool AddDiagSuppress(const std::string& suppress);
  bool SetVerbose(bool bVerbose);
  bool SetFileUnderTest(const std::string& filename);
  bool AddRefPackFile(const std::string& includeFile);
  bool SetPackNamePath(const std::string& packNamePath);
  bool SetUrlRef(const std::string& urlRef);
  bool ConfigureProgramName(const std::string& programPath);
  bool SetIgnoreOtherPdscFiles(bool bIgnore);
  bool GetIgnoreOtherPdscFiles();
  bool AddRefPdscFile(const std::string& filename);
  bool HaltProgramExecution();

  std::string GetCurrentDateTime();

  const std::string GetHeader();
  const std::string GetVersion();
  const std::string GetVersionInfo();
  const std::string GetProgramName();
  const std::string& GetUrlRef();
  const std::string& GetPackTextfileName();
  const std::string& GetPdscFullpath();
  const std::string& GetLogPath();

  const std::set<std::string>& GetPdscRefFullpath();

  bool IsSkipOnPdscTest(const std::string& filename);

private:
  bool m_bIgnoreOtherPdscFiles;

  std::string m_urlRef;    // package URL reference, check the URL of the PDSC against this value. if not std::set it is compared against the Keil Pack Server URL
  std::string m_packNamePath;
  std::string m_packToCheck;
  std::string m_logPath;
  std::string m_programName;
  std::set<std::string> m_packsToRef;
};

#endif // PACKOPTIONS_H

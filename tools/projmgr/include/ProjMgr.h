/*
 * Copyright (c) 2020-2021 Arm Limited. All rights reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef PROJMGR_H
#define PROJMGR_H

#include "ProjMgrParser.h"
#include "ProjMgrWorker.h"
#include "ProjMgrGenerator.h"

 /**
  * @brief projmgr class
 */
class ProjMgr {
public:
  /**
   * @brief class constructor
  */
  ProjMgr(void);

  /**
   * @brief class destructor
  */
  ~ProjMgr(void);

  /**
   * @brief entry point for running projmgr
   * @param argc command line argument count
   * @param argv command line argument vector
  */
  static int RunProjMgr(int argc, char **argv);

  /**
   * @brief print usage
  */
  void PrintUsage(void);

  /**
   * @brief show version
  */
  void ShowVersion(void);

  /**
   * @brief get parser object
   * @return reference to m_parser
  */
  ProjMgrParser& GetParser(void) { return m_parser; };

  /**
   * @brief get worker object
   * @return reference to m_worker
  */
  ProjMgrWorker& GetWorker(void) { return m_worker; };

  /**
   * @brief get generator object
   * @return reference to m_generator
  */
  ProjMgrGenerator& GetGenerator(void) { return m_generator; };

  /**
   * @brief get cdefault file in solution/project or in installation directory
   * @return true if file is found successfully, false otherwise
  */
  bool GetCdefaultFile(void);

protected:
  ProjMgrParser m_parser;
  ProjMgrWorker m_worker;
  ProjMgrGenerator m_generator;

  std::string m_cprojectFile;
  std::string m_csolutionFile;
  std::string m_cdefaultFile;
  std::string m_context;
  std::string m_filter;
  std::string m_codeGenerator;
  std::string m_command;
  std::string m_args;
  std::string m_rootDir;
  std::string m_outputDir;
  std::string m_outputType;
  std::string m_loadPacksPolicy;
  bool m_checkSchema;
  bool m_missingPacks;
  GroupNode m_files;

  bool RunConvert(void);
  bool RunCodeGenerator(void);
  bool RunListPacks(void);
  bool RunListBoards(void);
  bool RunListDevices(void);
  bool RunListComponents(void);
  bool RunListDependencies(void);
  bool RunListContexts(void);
  bool RunListGenerators(void);
  bool PopulateContexts(void);
};

#endif  // PROJMGR_H
